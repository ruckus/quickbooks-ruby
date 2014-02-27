# Quickbooks-Ruby

[![Build Status](https://travis-ci.org/ruckus/quickbooks-ruby.png?branch=master)](https://travis-ci.org/ruckus/quickbooks-ruby)

Integration with Quickbooks Online via the Intuit Data Services v3 REST API.

**NOTE**: If you are looking for the v2 API then you need to use my other library - Quickeebooks:

https://github.com/ruckus/quickeebooks

This library communicates with the Quickbooks Data Services `v3` API, documented at:

[Data Services v3](https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services)

## Changes in 0.1.x from 0.0.x

`0.1.0` introduced a backwards-incompatible change in how boolean attributes are handled. As of `0.1.0` any boolean like:

`xml_accessor :active?, :from => 'Active'`

will be accessible via `active?`. Thereby eliminating custom code like:

```ruby
def active?
  active.to_s == 'true'
end
```

Now a call to `active?` that is not set will return `nil`. Otherwise it return `true` / `false`.
Moreover, there is no longer a getter method e.g. `active` (without the trailing `?`).

## Requirements

This has been tested on 1.9.3, 2.0.0, and 2.1.0.

Ruby 1.8.7 and 1.9.2 are not supported.

## Dependencies

Gems:

* `oauth`
* `roxml` : Workhorse for (de)serializing objects between Ruby & XML
* `nokogiri` : XML parsing
* `active_model` : For validations

## Getting Started & Initiating Authentication Flow with Intuit

What follows is an example using Rails but the principles can be adapted to any other framework / pure Ruby.

Create a Rails initializer with:

```ruby
QB_KEY = "your apps Intuit App Key"
QB_SECRET = "your apps Intuit Secret Key"

$qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
    :site                 => "https://oauth.intuit.com",
    :request_token_path   => "/oauth/v1/get_request_token",
    :authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
    :access_token_path    => "/oauth/v1/get_access_token"
})
```

To start the authentication flow with Intuit you include the Intuit Javascript and on a page of your choosing you present the "Connect to Quickbooks" button by including this XHTML:


```HTML
<!-- somewhere in your document include the Javascript -->
<script type="text/javascript" src="https://appcenter.intuit.com/Content/IA/intuit.ipp.anywhere.js"></script>

<!-- configure the Intuit object: 'grantUrl' is a URL in your application which kicks off the flow, see below -->
<script>
intuit.ipp.anywhere.setup({menuProxy: '/path/to/blue-dot', grantUrl: '/path/to/your-flow-start'});
</script>

<!-- this will display a button that the user clicks to start the flow -->
<ipp:connectToIntuit></ipp:connectToIntuit>
```

Your Controller action (the `grantUrl` above) should look like this:

```ruby
  def authenticate
    callback = quickbooks_oauth_callback_url
    token = $qb_oauth_consumer.get_request_token(:oauth_callback => callback)
    session[:qb_request_token] = token
    redirect_to("https://appcenter.intuit.com/Connect/Begin?oauth_token=#{token.token}") and return
  end
```

Where `quickbooks_oauth_callback_url` is the absolute URL of your application that Intuit should send the user when authentication succeeds. That action should look like:

```ruby
def oauth_callback
	at = session[:qb_request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
	token = at.token
	secret = at.secret
	realm_id = params['realmId']
	# store the token, secret & RealmID somewhere for this user, you will need all 3 to work with Quickbooks-Ruby
end
```
:star: Also, check out regular Quickbooks-Ruby contributor, <a href="https://github.com/minimul" target="_blank">minimul</a>'s, article [Integrating Rails and QuickBooks Online via the version 3 API](http://minimul.com/integrating-rails-and-quickbooks-online-via-the-version-3-api-part-1.html) for a step-by-step guide along with screencasts.

## Creating an OAuth Access Token

Once you have your users OAuth Token & Secret you can initialize your `OAuth Consumer` and create a `OAuth Client` using the `$qb_oauth_consumer` you created earlier in your Rails initializer:

```ruby
access_token = OAuth::AccessToken.new($qb_oauth_consumer, access_token, access_secret)
```

## Getting Started - Retrieving a list of Customers

The general approach is you first instantiate a `Service` object based on the entity you would like to retrieve. Lets retrieve a list of Customers:

```ruby

service = Quickbooks::Service::Customer.new
service.company_id = "123" # also known as RealmID
service.access_token = access_token # the OAuth Access Token you have from above

customers = service.query() # Called without args you get the first page of results

# yields

customers.entries = [ .. array of Quickbooks::Model::Customer objects .. ]
customers.start_position = 1 # the current position in the paginated set
customers.max_results = 20 # the maximum number of results in this query set
```

Under the hood Intuit uses a simple SQL-like dialect for retrieving objects, the above no-arg use of `query()` issued a `Select * From Customer`.

You can issue your own query by passing the complete and valid query as the first argument:

```ruby
customers.query("Select Id, GivenName From Customer")
```

Each Entity has different fields you can retrieve & filter on. Refer to Intuit documentation for details.

### Pagination

Do not pass pagination parameters in your query - pass them as additional options, using `:page` and `:per_page`:

```ruby
# to use the default query
customers.query(nil, :page => 2, :per_page => 25)

# to use a custom query: find customers updated recently and only select a few attributes
query = "Select Id, GivenName From Customer Where Metadata.LastUpdatedTime>'2013-03-13T14:50:22-08:00' Order By Metadata.LastUpdatedTime"
customers.query(query, :page => 2, :per_page => 25)
```

## Retrieving a single object

You can retrieve a specific Intuit object like so:

```ruby
customer = service.fetch_by_id("99")
puts customer.company_name
=> "Acme Enterprises"
```

## Updating an object

By default updating an object will un-set any attributes that are NOT specified in the update request. That is, the update is NOT sparse by default.
Thus, be careful as you might accidentally unset attributes that you did not specify.

Example:

```ruby

# fetch a Customer to change their name
customer = service.fetch_by_id("99")
customer.company_name = "Neo Pets"
service.update(customer)
```

In the above example since we retrieved all fields and then just changed a single attribute, we have given the "complete" entity back to Intuit
and effectively only the name is changed.

If you don't have the complete object on hand and only want to change a couple of attributes without un-setting what you are not specifying than you want to use a sparse update:

```ruby
# update a Customer's name when we only know their ID
customer = Quickbooks::Customer::Model.new
customer.id = 99
customer.company_name = "New Company Name"
service.update(customer, :sparse => true)
```

## Generating an Invoice

A complete example on generating a basic invoice:

```ruby
# Given a Customer with ID=99 lets invoice them for an Item with ID=500
invoice = Quickbooks::Model::Invoice.new
invoice.customer_id = 99
invoice.txn_date = Date.civil(2013, 11, 20)
invoice.doc_number = "1001" # my custom Invoice # - can leave blank to have Intuit auto-generate it

line_item = Quickbooks::Model::InvoiceLineItem.new
line_item.amount = 50
line_item.description = "Plush Baby Doll"
line_item.sales_item! do |detail|
  detail.unit_price = 50
  detail.quantity = 1
  detail.item_id = 500 # Item ID here
end

invoice.line_items << line_item

service = Quickbooks::Service::Invoice.new
service.company_id = "123"
service.access_token = access_token
created_invoice = service.create(invoice)
puts created_invoice.id
=> 234
```

**Notes**: `line_item.amount` must equal the `unit_price * quantity` in the sales detail packet - otherwise Intuit will raise an exception.

## Deleting an Object

Use `Service#delete` which returns a boolean on whether the delete operation succeeded or not.

```ruby
service.delete(customer)
=> returns boolean
```

## Logging

```ruby
Quickbooks.log = true
```
By default, logging is directed at STDOUT, but another target may be defined, e.g. in Rails
```ruby
Quickbooks.logger = Rails.logger
Quickbooks.log = true
```

## Entities Implemented

Entity            | Create | Update | Query | Delete | Fetch by ID | Other
---               | ---    | ---    | ---   | ---    | ---         | ---
Account           | yes    | yes    | yes   | yes    | yes         |
Attachable        | no     | no     | no    | no     | no          |
Bill              | yes    | yes    | yes   | yes    | yes         |
Bill Payment      | yes    | yes    | yes   | yes    | yes         |
Class             | no     | no     | no    | no     | no          |
Company Info      | n/a    | n/a    | yes   | n/a    | yes         |
Credit Memo       | yes    | yes    | yes   | no     | no          |
Customer          | yes    | yes    | yes   | yes    | yes         |
Department        | no     | no     | no    | no     | no          |
Employee          | yes    | yes    | yes   | yes    | yes         |
Entitlements      | no     | no     | no    | no     | no          |
Estimate          | yes    | yes    | yes   | yes    | yes         |
Invoice           | yes    | yes    | yes   | yes    | yes         |
Item              | yes    | yes    | yes   | yes    | yes         |
Journal Entry     | no     | no     | no    | no     | no          |
Payment           | yes    | yes    | yes   | yes    | yes         |
PaymentMethod     | yes    | yes    | yes   | yes    | yes         |
Preferences       | no     | no     | no    | no     | no          |
Purchase          | yes    | yes    | yes   | yes    | yes         |
Purchase Order    | yes    | yes    | yes   | yes    | yes         |
Sales Receipt     | yes    | yes    | yes   | yes    | yes         |
Sales Rep         | no     | no     | no    | no     | no          |
Sales Tax         | no     | no     | no    | no     | no          |
Sales Term        | no     | no     | no    | no     | no          |
Tax Code          | no     | no     | yes   | no     | no          |
Tax Rate          | no     | no     | yes   | no     | no          |
Term              | yes    | yes    | yes   | yes    | yes         |
Time Activity     | yes    | yes    | yes   | yes    | yes         |
Tracking Class    | no     | no     | no    | no     | no          |
Vendor            | yes    | yes    | yes   | yes    | yes         |
Vendor Credit     | yes    | yes    | yes   | yes    | yes         |


## TODO

* Implement other Line Item types, e.g. `DescriptionLineDetail` for Invoices

## Author

Cody Caughlan

## Contributors
`quickbooks-ruby` has been a community effort and I am thankful for all the amazing contributors. If I have missed
your name please email me or submit a Pull Request.

* Bruno Buccolo
* Christian
* Eggy
* Evan Walsh
* Exe Curia
* Jason Dew
* jleo3
* Joe Wright
* Josh Wilson
* Pavel Pachkovskij
* Sean Xie
* Steven Chau
* Washington Luiz

## License

The MIT License

Copyright (c) 2013

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Quickbooks-Ruby

[![Join the chat at https://gitter.im/ruckus/quickbooks-ruby](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/ruckus/quickbooks-ruby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/ruckus/quickbooks-ruby.png?branch=master)](https://travis-ci.org/ruckus/quickbooks-ruby)

Integration with Quickbooks Online via the Intuit Data Services v3 REST API.

This library communicates with the Quickbooks Data Services `v3` API, documented at:

[Data Services v3](https://developer.intuit.com/docs/api/accounting)

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

This has been tested on 1.9.3, 2.0, 2.1, 2.2

Ruby 1.8.7 and 1.9.2 are not supported.

## Dependencies

Gems:

* `oauth`
* `oauth2`
* `roxml` : Workhorse for (de)serializing objects between Ruby & XML
* `nokogiri` : XML parsing
* `active_model` : For validations

## Sandbox Mode
An API app provides two sets of OAuth key for production and development. Since October 22, 2014, only [Sandbox Companies](https://developer.intuit.com/docs/api/accounting)
are allowed to connected to the QBO via the development key. The end-point for sandbox mode is https://sandbox-quickbooks.api.intuit.com.

By default, the gem runs in production mode. If you prefer to develop / test the integration with the development key,
you need to config the gem to run in sandbox mode:

```ruby
Quickbooks.sandbox_mode = true
```

## Authorization through OAuth 2.0
This section is only for developer accounts that uses OAuth 2.0 for the apps. For apps that are authorized by OAuth 1, please refer to the next section.

### Getting Started & Initiating Authentication Flow with Intuit

What follows is an example using Rails but the principles can be adapted to any other framework / pure Ruby.

Create a Rails initializer with:

```ruby
OAUTH_CONSUMER_KEY = ENV["OAUTH_CONSUMER_KEY"]
OAUTH_CONSUMER_SECRET = ENV["OAUTH_CONSUMER_SECRET"]

oauth_params = {
  :site => "https://appcenter.intuit.com/connect/oauth2",
  :authorize_url => "https://appcenter.intuit.com/connect/oauth2",
  :token_url => "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer"
}

::QB_OAUTH2_CONSUMER = OAuth2::Client.new(OAUTH_CONSUMER_KEY, OAUTH_CONSUMER_SECRET, oauth_params)

```

Your Controller action (the `grantUrl` above) should look like this:

```ruby
def authenticate
  redirect_uri = quickbooks_oauth_callback_url
  grant_url = ::QB_OAUTH2_CONSUMER.auth_code.authorize_url(:redirect_uri => redirect_uri, :response_type => "code", :state => SecureRandom.hex(12), :scope => "com.intuit.quickbooks.accounting")
  redirect_to grant_url
end
```

Where `quickbooks_oauth_callback_url` is the absolute URL of your application that Intuit should send the user when authentication succeeds.

That action should look like:

```ruby
def oauth_callback
  if params[:state]
    redirect_uri = oauth_callback_quickbooks_url
    if resp = ::QB_OAUTH2_CONSUMER.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
      # save your tokens here. For example:
      # quickbooks_credentials.update_attributes(access_token: resp.token, refresh_token: resp.refresh_token, realm_id: params[:realmId])
    end
  end
end
```

Most likely you will want to persist the OAuth access credentials so that users don't need to re-authorize your application in every session.

An example database table would have fields likes:

```sql
access_token varchar(255),
refresh_token varchar(255),
realm_id varchar(255)
```

### Creating an OAuth Access Token

Once you have your user's OAuth token, you can re-use the `OAuth Consumer` and create a `OAuth Client` using the `QB_OAUTH2_CONSUMER` you created earlier in your Rails initializer:

```ruby
qb_access_token = quickbooks_credentials.access_token
qb_refresh_token = quickbooks_credentials.refresh_token

access_token = OAuth2::AccessToken.new(::QB_OAUTH2_CONSUMER, qb_access_token, { :refresh_token => qb_refresh_token })
```

### Access Token Validity and Token Refresh

Each access token is only valid for one hour. The access token and refresh token can be refreshed directly by using OAuth Client:

```ruby
new_access_token = access_token.refresh!
```

The token must be assigned to a variable to prevent the loss of your new access token, which will void your credentials and a new set of credentials have to be acquired by authorizing the application again.
Unauthorized (expired) access to the API will raise a `OAuth2::Error` error.

For more information on access token expiration and refresh token expiration, please refer to the [official documentation](https://developer.intuit.com/app/developer/qbo/docs/develop/authentication-and-authorization/oauth-2.0#understand-token-expiration).

### Credentials Encryption
For simplicity, this example does not encrypt the access credentials. If you are developing an app and
plan on publishing it to Intuit's marketplace you will need to encrypt the credentials to comply with
their [security requirements](https://developer.intuit.com/app/developer/qbo/docs/list-on-the-app-store/security-requirements).
We'd suggest looking at the [attr_encrypted gem](https://github.com/attr-encrypted/attr_encrypted) to
handle the actual encryption and decryption.

## Authorization through OAuth 1
### Getting Started & Initiating Authentication Flow with Intuit

What follows is an example using Rails but the principles can be adapted to any other framework / pure Ruby.

Create a Rails initializer with:

```ruby
OAUTH_CONSUMER_KEY = "OAUTH_CONSUMER_KEY"
OAUTH_CONSUMER_SECRET = "OAUTH_CONSUMER_SECRET"

::QB_OAUTH_CONSUMER = OAuth::Consumer.new(OAUTH_CONSUMER_KEY, OAUTH_CONSUMER_SECRET, {
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
    token = QB_OAUTH_CONSUMER.get_request_token(:oauth_callback => callback)
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
**NOTE**: If you are using Rails 4.1, you will need to wrap the token in Marshal.load and Marshal.dump:

```ruby
session[:qb_request_token] = Marshal.dump(token)
```

```ruby
Marshal.load(session[:qb_request_token]).get_access_token(:oauth_verifier => params[:oauth_verifier])
```

:star: Also, check out regular Quickbooks-Ruby contributor, [minimul](https://github.com/minimul)'s, article [Integrating Rails and QuickBooks Online via the version 3 API](http://minimul.com/integrating-rails-and-quickbooks-online-via-the-version-3-api-part-1.html) for a step-by-step guide along with screencasts.

### Creating an OAuth Access Token

Once you have your users OAuth Token & Secret you can initialize your `OAuth Consumer` and create a `OAuth Client` using the `QB_OAUTH_CONSUMER` you created earlier in your Rails initializer:

```ruby
access_token = OAuth::AccessToken.new(QB_OAUTH_CONSUMER, string_access_token_from_qb, string_access_secret_from_qb)
```

### Persisting the Credentials

Most likely you will want to persist the OAuth access credentials so you don't have to connect to QBO
each and every time.

The access credentials are valid for 180 days. 30 days before they expire, they can be renewed. You'll need
to keep track of the expiration date and manage the renewal process yourself.

An example database table would have fields likes:

```sql
access_token varchar(255),
access_secret varchar(255),
company_id varchar(255),
token_expires_at datetime # Set to 180.days.from_now upon insertion
```

Then you will want to have a scheduled task which runs nightly looking for records `where('token_expires_at < ?', 30.days.from_now)` and then performs the renewal:

```ruby
expiring_tokens.each do |record|
  access_token = OAuth::AccessToken.new(QB_OAUTH_CONSUMER, record.access_token, record.access_secret)
  service = Quickbooks::Service::AccessToken.new
  service.access_token = access_token
  service.company_id = record.company_id
  new_token = service.renew

  case new_token.error_code
  when "0" # Success
    # Update the stored values
    record.update_attributes!(
      access_token: new_token.token,
      access_secret: new_token.secret,
      token_expires_at: 180.days.from_now.utc,
    )
    puts "Renewal succeeded"
  when "270" # The OAuth access token has expired.
    # Discard any saved credentials, need to restart the OAuth process
    record.update_attributes!(
      access_token: nil,
      access_secret: nil,
      token_expires_at: nil,
    )
    puts "Renewal failed"
  when "212" # Token Refresh Window Out of Bounds
    # Tried to renew it more than 30 days before expiration
    puts "Renewal ignored, tried too soon"
  else
    puts "Renewal failed, code: #{new_token.error_code} message: #{new_token.error_message}"
  end
end
```

For simplicity, this example does not encrypt the access credentials. If you are developing an app and
plan on publishing it to Intuit's marketplace you will need to encrypt the credentials to comply with
their [security requirements](https://developer.intuit.com/docs/0100_quickbooks_online/0100_essentials/0085_develop_quickbooks_apps/0006_publish_and_market_your_app_with_quickbooks/0005_security_requirements).
We'd suggest looking at the [attr_encrypted gem](https://github.com/attr-encrypted/attr_encrypted) to
handle the actual encryption and decryption.

### Revoke token/disconnect

It is possible to revoke access given to it by a specific user using the `Quickbooks::Service::AccessToken#disconnect` method.
For more information on how to revoke an access token, please refer to the [official documentation](https://developer.intuit.com/app/developer/qbo/docs/develop/authentication-and-authorization/oauth-2.0#revoke-token-disconnect).

```ruby
qb_access_token = quickbooks_credentials.access_token
qb_refresh_token = quickbooks_credentials.refresh_token

access_token = OAuth2::AccessToken.new(::QB_OAUTH2_CONSUMER, qb_access_token, { :refresh_token => qb_refresh_token })
qb_access_token = Quickbooks::Service::AccessToken.new(access_token: access_token)
disconnect_response = qb_access_token.disconnect
puts disconnect_response.error?
```

## Getting Started - Retrieving a list of Customers

The general approach is you first instantiate a `Service` object based on the entity you would like to retrieve. Lets retrieve a list of Customers:

```ruby

service = Quickbooks::Service::Customer.new
service.company_id = "123" # also known as RealmID
service.access_token = access_token # the OAuth Access Token you have from above

# Equivalent to Quickbooks::Service::Customer.new(:company_id => "123", :access_token => access_token)

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
### Querying in Batches

Often one needs to retrieve multiple pages of records of an Entity type
and loop over them all. Fortunately there is the `query_in_batches` collection method:

```ruby
query = nil
Customer.query_in_batches(query, per_page: 1000) do |batch|
  batch.each do |customer|
    # ...
  end
end
```

The first argument to `query_in_batches` is the `query` (which
can be `nil` to retrieve the default items in that collection).
If you're are running a custom Query then pass it instead.

The second argument is the options, which are optional.
By default, the options are `per_page: 1000`.

## Retrieving all objects

You may retrieve an array of objects like so:
```ruby
customers = service.all
```
Unlike other query functions which return a Quickbooks::Collection object,
the all method returns an array of objects.

## Retrieving a single object

You can retrieve a specific Intuit object like so:

```ruby
customer = service.fetch_by_id("99")
puts customer.company_name
=> "Acme Enterprises"
```
## Retrieving objects with matching attributes

The `find_by(attribute, value)` method allows you to retrieve objects with a simple WHERE query using a single attribute.  The attribute may be given as a symbol or a string.
Symbols will be automatically camelcased to match the Quickbooks API field names.

```ruby
customer = service.find_by(:family_name, "Doe")
or
customer = service.find_by("FamilyName", "Doe")
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
customer = Quickbooks::Model::Customer.new
customer.id = 99
customer.company_name = "New Company Name"
service.update(customer, :sparse => true)
```

## Reference Setters

Some models require a reference to be set, to a Customer, or an Item, etc. In the Quickbooks API these references
are labeled via a property like `CustomerRef`. In `quickbooks-ruby` the assignment of these references is done
by using the setter on the `_id` property.

For example, to specify a Customer with ID 99 on an Invoice you would do this:

```ruby
invoice = Quickbooks::Model::Invoice.new
invoice.customer_id = 99
```

This will automatically set a `CustomerRef` XML packet with a value of 99.


## SalesReceipts & Ship Methods

The QBO API documentation states that `SalesReceipt` has a `ShipMethodRef` attribute. Normally, all attributes of a `Ref` type
take an pseudo-integer argument, representing the foreign ID, which in turn point to a valid object with that ID.

I say *pseudo* because they look like Integers but Intuit has made it clear they should be handled as strings.

Anyways, its subtle but the value for a `SalesReceipt#ShipMethodRef` while it is a `BaseReference` needs to be set manually:

```ruby
shipping_reference = Quickbooks::Model::BaseReference.new('FedEx', name: 'FedEx')
receipt.ship_method_ref = shipping_reference
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

## Generating an Invoice containing a Bundle

Example (code fragments) of adding a bundle line item, to an invoice:

```ruby
items = service.find_by(:sku, 'AHH_SWEETS')
bundle = items.entries.first
# be sure to check if you found the bundle you want
# ...

line_item = Quickbooks::Model::InvoiceLineItem.new
  line_item.description = bundle.description

  line_item.group_line_detail! do |detail|
    detail.id = bundle.id
    detail.group_item_ref = Quickbooks::Model::BaseReference.new(bundle.name, value: bundle.id)
    detail.quantity = 1

    bundle.item_group_details.line_items.each do |l|
      g_line_item = Quickbooks::Model::InvoiceLineItem.new
      g_line_item.amount = 50

      g_line_item.sales_item! do |gl|
        gl.item_id    = l.id
        gl.quantity   = 1
        gl.unit_price = 50
      end

      detail.line_items << g_line_item
    end
  end

  invoice.line_items << line_item
```

## Emailing Invoices

The Quickbooks API offers a **send invoice** feature that sends the specified invoice model via email.  By default the email is sent to the `bill_email` on the invoice.  This feature returns an invoice model with updated `email_status` and `delivery_info` as shown below:

```ruby
invoice = invoice_service.fetch_by_id("1")
sent_invoice = invoice_service.send(invoice)

puts sent_invoice.email_status
=> EmailSent
puts sent_invoice.delivery_info.delivery_type
=> Email
puts sent_invoice.delivery_info.delivery_time
=> Wed, 25 Feb 2015 18:56:04 UTC +00:00
```

It is possible to email the invoice to an altermate email address by including the email as a second parameter in the `invoice.send` method.  When a new email address is provided the invoice model that is returned will have the `bill_email` set to the new email address as show below:

```ruby
invoice = invoice_service.fetch_by_id("1")
sent_invoice = invoice_service.send(invoice, "name@domain.com")

puts send_invoice.bill_email.address
=> name@domain.com
```

**Notes:** Quickbooks has global company settings to customize the send invoice email message content and format.

## Generating a SalesReceipt

```ruby
#Invoices, SalesReceipts etc can also be defined in a single command
salesreceipt = Quickbooks::Model::SalesReceipt.new({
  customer_id: 99,
  txn_date: Date.civil(2013, 11, 20),
  payment_ref_number: "111", #optional payment reference number/string - e.g. stripe token
  deposit_to_account_id: 222, #The ID of the Account entity you want the SalesReceipt to be deposited to
  payment_method_id: 333 #The ID of the PaymentMethod entity you want to be used for this transaction
})
salesreceipt.auto_doc_number! #allows Intuit to auto-generate the transaction number

line_item = Quickbooks::Model::Line.new
line_item.amount = 50
line_item.description = "Plush Baby Doll"
line_item.sales_item! do |detail|
  detail.unit_price = 50
  detail.quantity = 1
  detail.item_id = 500 # Item (Product/Service) ID here
end

salesreceipt.line_items << line_item

service = Quickbooks::Service::SalesReceipt.new({access_token: access_token, company_id: "123" })
created_receipt = service.create(salesreceipt)
```

**Notes**: In order to auto-generate transaction numbers using `salesreceipt.auto_doc_number!`, the 'Custom Transaction Numbers' setting under Company Settings>Sales Form Entry must be **unchecked** within the Quickbooks account you are posting to.


## Deleting an Object

Use `Service#delete` which returns a boolean on whether the delete operation succeeded or not.

```ruby
service.delete(customer)
=> returns boolean
```

## Email Addresses

Email attributes are not just strings, they are top-level objects, e.g. `EmailAddress` on a `Customer` for instance.

A `Customer` has a setter method to make assigning an email address easier.

```ruby
customer = Quickbooks::Model::Customer.new
customer.email_address = "foo@example.com"
```

## Telephone Numbers

Like Email Addresses, telephone numbers are not just basic strings but are top-level objects.

```ruby
phone1 = Quickbooks::Model::TelephoneNumber.new
phone1.free_form_number = "97335530394"
customer.mobile_phone = phone1
```

## Physical Addresses

Addresses are also top-level objects, so they must be instantiated and set.

```ruby
address = Quickbooks::Model::PhysicalAddress.new

address.line1 = "2200 Mission St."
address.line2 = "Suite 201"
address.city = "Santa Cruz"
address.country_sub_division_code = "CA" # State, in United States
address.postal_code = "95060"
customer.billing_address = address
```

## Batch Operations

You can batch operations such creating an Invoice, updating a Customer, etc. The maximum batch size is 25 objects.

How to use:

```ruby
batch_req = Quickbooks::Model::BatchRequest.new

customer = Quickbooks::Model::Customer.new
# build the customer as needed
...

item = Quickbooks::Model::Item.new
# build the item as needed
...

batch_req.add("bId1", customer, "create")
batch_req.add("bId2", item, "create")

# Add more items to create/update as needed, up to 25

batch_service = Quickbooks::Service::Batch.new
batch_response = batch_service.make_request(batch_req)
batch_response.response_items.each do |res|
  puts res.bId
  puts res.fault? ? "error" : "success"
end
```

For complete details on Batch Operations see:
https://developer.intuit.com/docs/api/accounting/batch

## Query Building / Filtering
Intuit requires that complex queries be escaped in a certain way. To make it easier to build queries that will be accepted I have provided a *basic* Query builder.

```ruby
util = Quickbooks::Util::QueryBuilder.new

# the method signature is: clause(field, operator, value)
clause1 = util.clause("DisplayName", "LIKE", "%O'Halloran")
clause2 = util.clause("CompanyName", "=", "Smith")

service.query("SELECT * FROM Customer WHERE #{clause1} AND #{clause2}")
```

## Attachments

The Quickbooks API supports two different types of attachments, depending on whether you have an actual file to upload or just
want to upload "meta-data" about an operation.

### Meta-data only: use the `Attachment` service

```ruby
meta = Quickbooks::Model::Attachable.new
meta.file_name = "monkey.jpg"
meta.note = "A note"
meta.content_type = "image/jpeg"
entity = Quickbooks::Model::BaseReference.new(3, type: 'Customer')
meta.attachable_ref = Quickbooks::Model::AttachableRef.new(entity)
```

*Note*: No actual file is being attached, we are just describing a file.


### Uploading an actual file

```ruby
upload_service = Quickbooks::Service::Upload.new

# args:
#     local-path to file
#     file mime-type
#     (optional) instance of Quickbooks::Model::Attachable - metadata
result = upload_service.upload("tmp/monkey.jpg", "image/jpeg", attachable_metadata)
```

If successful `result` will be an instance of the `Attachable` model:

```
puts attach.temp_download_uri

=> "https://intuit-qbo-prod-29.s3.amazonaws.com/12345%2Fattachments%2Fmonkey-1423760870606.jpg?Expires=1423761772&AWSAcc ... snip ..."
```

### Download PDF of an Invoice or SalesReceipt

To download a PDF of an Invoice:

```ruby
service = Quickbooks::Service::Invoice.new # or use the SalesReceipt service

# +invoice+ is an instance of Quickbooks::Model::Invoice
raw_pdf_data = service.pdf(invoice)

# write it to disk
File.open("invoice.pdf", "wb") do |file|
  file.write(raw_pdf_data)
end
```

## Change Data Capture

Quickbooks has an api called Change Data Capture that provides a way of finding out which Entities have recently changed, as deleted entities will not be returned by a standard query. It is possible to request changes up to 30 days ago.

The primary method for querying to ChangeDataCapture is through Quickbooks::Service::ChangeDataCapture.

Quickbooks::Model::ChangeDataCapture also supports parsing the XML response into a hash of entity types through the all_types method.

```ruby
service = Quickbooks::Service::ChangeDataCapture.new
...
# define the list of entities to query
entities = ["Invoice", "Bill", "Payment"] #etc
changed = service.since(entities, Time.now.utc - 5.days)
...
# parse the XML to a list of Quickbooks::Models
changed_as_hash = changed.all_types
```

Deleted entities can be found in the XML by checking their @status is "Deleted". In the return from the all_types method, deleted items will be of type Quickbooks::Model::ChangeModel.

see: https://developer.intuit.com/docs/0100_quickbooks_online/0200_dev_guides/accounting/change_data_capture for more information.

## ChangeModel alternative Change Data Capture For Invoices, Customers, Vendors, Items, Payments and Credit Memos

It is possible to get a sparse summary of which Invoice, Customer, Vendor, Item, Payment or Credit Memo Entries have recently changed.
It is possible to request changes up to 30 days ago.

```ruby
service = Quickbooks::Service::InvoiceChange.new
...
changed = service.since(Time.now.utc - 5.days)
```

```ruby
customer_service = Quickbooks::Service::CustomerChange.new
...
customer_changed = customer_service.since(Time.now.utc - 5.days)
```

```ruby
vendor_service = Quickbooks::Service::VendorChange.new
...
vendor_changed = vendor_service.since(Time.now.utc - 5.days)
```

```ruby
item_service = Quickbooks::Service::ItemChange.new
...
item_changed = item_service.since(Time.now.utc - 5.days)
```
see: https://developer.intuit.com/docs/0100_quickbooks_online/0200_dev_guides/accounting/change_data_capture for more information.

## Reports API

Quickbooks has an API called the [Reports API](https://developer.intuit.com/docs/0100_accounting/0400_references/reports) that provides abilities such as: business and sales overview; vendor and customer balances; review expenses and purchases and more.
See the [specs](https://github.com/ruckus/quickbooks-ruby/blob/master/spec/lib/quickbooks/model/report_spec.rb) for [examples](https://github.com/ruckus/quickbooks-ruby/blob/master/spec/lib/quickbooks/service/reports_spec.rb) of how to leverage.

## JSON support

Intuit started the v3 API supporting both XML and JSON. However, new
v3 API services such as `Tax Service` [will only support
JSON]( https://github.com/ruckus/quickbooks-ruby/issues/257#issuecomment-126834454 ). This gem has
[ roots ](https://github.com/ruckus/quickeebooks) in the v2 API, which was XML only, and hence was constructed supporting XML only.

That said, the `Tax Service` is supported and other new v3-API-JSON-only services will be supported. Ideally, we would like to fully support JSON for all entities and services for the `1.0.0` release. Please jump in and contribute to help that aim.

## Logging

```ruby
Quickbooks.log = true
```
By default, logging is directed at STDOUT, but another target may be defined, e.g. in Rails
```ruby
Quickbooks.logger = Rails.logger
Quickbooks.log = true
# Pretty-printing logged xml is true by default
Quickbooks.log_xml_pretty_print = false
```

## Debugging

While logging is helpful the best debugging (in my opinion) is available by using a HTTP proxy such as [Charles Proxy](https://www.charlesproxy.com/).

To enable HTTP proxying you pass in `:http_proxy` when you generate your OAuth Consumer:

```ruby
$qb = OAuth::Consumer.new($consumer_key, $consumer_secret, {
    :site                 => "https://oauth.intuit.com",
    :request_token_path   => "/oauth/v1/get_request_token",
    :authorize_path       => "/oauth/v1/get_access_token",
    :access_token_path    => "/oauth/v1/get_access_token",
    :proxy => "http://127.0.0.1:8888"
})
```

## Entities Implemented

Entity            | Create | Update | Query | Delete | Fetch by ID | Other
---               | ---    | ---    | ---   | ---    | ---         | ---
Account           | yes    | yes    | yes   | yes    | yes         |
Attachable        | no     | no     | no    | no     | no          |
Bill              | yes    | yes    | yes   | yes    | yes         |
Bill Payment      | yes    | yes    | yes   | yes    | yes         |
Class             | yes    | yes    | yes   | yes    | yes         |
Company Info      | n/a    | n/a    | yes   | n/a    | yes         |
Credit Memo       | yes    | yes    | yes   | yes    | no          |
Customer          | yes    | yes    | yes   | yes    | yes         |
Department        | yes    | yes    | yes   | yes    | yes         |
Deposit           | yes    | yes    | yes   | yes    | yes         |
Employee          | yes    | yes    | yes   | yes    | yes         |
Entitlements      | no     | no     | no    | no     | no          |
Estimate          | yes    | yes    | yes   | yes    | yes         |
Invoice           | yes    | yes    | yes   | yes    | yes         |
Item              | yes    | yes    | yes   | yes    | yes         |
Journal Entry     | yes    | yes    | yes   | yes    | yes         |
Payment           | yes    | yes    | yes   | yes    | yes         |
PaymentMethod     | yes    | yes    | yes   | yes    | yes         |
Preferences       | n/a    | no     | yes   | n/a    | yes         |
Purchase          | yes    | yes    | yes   | yes    | yes         |
Purchase Order    | yes    | yes    | yes   | yes    | yes         |
Refund Receipt    | yes    | yes    | yes   | yes    | yes         |
Sales Receipt     | yes    | yes    | yes   | yes    | yes         |
Sales Rep         | no     | no     | no    | no     | no          |
Sales Tax         | no     | no     | no    | no     | no          |
Sales Term        | no     | no     | no    | no     | no          |
Tax Agency        | yes    | yes    | yes   | yes    | yes         |
Tax Code          | no     | no     | yes   | no     | no          |
Tax Rate          | yes    | yes    | yes   | no     | no          |
*Tax Service      | yes    | yes    | no    | no     | no          |
Term              | yes    | yes    | yes   | yes    | yes         |
Time Activity     | yes    | yes    | yes   | yes    | yes         |
Tracking Class    | no     | no     | no    | no     | no          |
Vendor            | yes    | yes    | yes   | yes    | yes         |
Vendor Credit     | yes    | yes    | yes   | yes    | yes         |

*JSON only

## Related GEMS

[`quickbooks-ruby-base`](https://github.com/minimul/quickbooks-ruby-base): Complements quickbooks-ruby by providing a [base class](http://minimul.com/improve-your-quickbooks-ruby-integration-experience-with-the-quickbooks-ruby-base-gem.html) to handle routine tasks like creating a model, service, and displaying information.

[`qbo_rails`](https://github.com/minimul/qbo_rails): Simple Rails error handling and QuickBooks Online "Id" persistence. Uses `quickbooks-ruby`.

## TODO

* Implement other Line Item types, e.g. `DescriptionLineDetail` for Invoices
* Full JSON support

## Author

Cody Caughlan

## Contributors
`quickbooks-ruby` has been a community effort and I am extremely thankful for all the [amazing contributors](https://github.com/ruckus/quickbooks-ruby/network/members).

## License

The MIT License

Copyright (c) 2013

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

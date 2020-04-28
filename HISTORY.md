## 1.0.7 (2020-04-28)

* Add customer type #509. Thank you @gbkane
* Fix NoMethodError when response headers are nil (#514). Thank you @anaprimawaty
* Update Readme about roxml BigDecimal deprecation (#516). Thank you @anaprimawaty
* Escape regex matching numbers in report parsing (#511). Thank you @mehwoot

## 1.0.6 (2020-02-10)

* Fix fetch_by_id in purchase order service (#505), thank you @atemena

## 1.0.5 (2020-01-28)

* Fixed Disconnect (dependency on oauth_v1? which was removed in 1.0.2)

## 1.0.4 (2020-01-22)

* Purchase Order: added MINORVERSION support. Also added Received property
* Add ability to download credit memo as pdf (#500) - Thanks @frenkel
* Finish update to rspec 3 (#499); Remove rspec-its; Convert specs to RSpec 3.9.0 syntax with Transpec. Thanks @drewish

## 1.0.3 (2020-01-08)

* Added customer.tax_exemption_reason_id (#495) . Thanks @bcackerman
* mxchan (thanks!)
    - fix Content-Type in send sales receipt (#498)
    - Fixes the `undefined method 'bytesize' for #<Hash...` error triggered when sending a sales receipt.
    - Searched around and found #412 which already implemented the fix for sending invoices, but hadn't been implemented for sales receipt yet.

## 1.0.2 (2019-12-19)

* Dropped OAuth1 support
* rspec updates. Thank you @drewish
* Update SalesFormsPref fields on Preferences model (#492). Thank you @drewish
* Better errors: Add more detail to AuthorizationFailures, Unwind logging and parsing code, Track last response's intuitTid. Thank you @drewish

## 1.0.1 (2019-11-05)

* Add minorversion to account service and update query url (#488). Thank you @colmheaney
* Use pessimistic version constraint on oauth dependency (#485). Thank you @austinmckinley

## 1.0.0 (2019-10-14)

* OAuth2. With support for OAuth1 in mixed-mode.

Thank you to everyone who has contributed!

## 0.6.7 (2019-07-24)

* Preferences sales_forms_prefs CustomField support
* Fix test failures due to logging call on Stubbed object
* Add CustomField#value accessor suitable for all CustomField types
* Add support for custom fields config in Preferences
* Change deprecated use of BigDecimal.new

Thank you @armstrjare


## 0.6.6 (2019-01-30)

* Implemented minorversion support for Customer (at 33)
* Added PrefVendorRef field support to Item

## 0.6.5 (2019-01-07)

* adding LinkedTxn collection into Quickbooks::Model::Bill per v3 API spec (#452), thank you @thaiden
* Relax oauth gem dependency (#449) allow anything >= 0.4.5 but < 0.5, thank you @jnraine
* Updates to the CompanyCurrency model, thank you @chrisgreen1993
* Add a base class to easily rescue all QBO exceptions (#445) Having all the errors inherit from a single class means you can just rescue `Quickbooks::Error` and handle all of this gem's exceptions. Thank you @drewish

## 0.6.4 (2018-10-29)

Yanked 0.6.3; built incorrectly. 0.6.4 has no functional differences between 0.6.3

## 0.6.3 (2018-10-21)

Added minorversion=21 support to Preferences

## 0.6.2 (2018-05-16)

Fixed bug with generating an invalid URL when both requestid and minorversions are specified. Addresses #430

## 0.6.1 (2018-01-31)

Added support for Description-only line item details on Invoices

Usage:

```
line_item = Quickbooks::Model::InvoiceLineItem.new
line_item.description = "Plush Baby Doll"
line_item.description_only!
invoice.line_items << line_item
```

## 0.6.0 (2018-01-25)

* Updated dependent gem ROXML to 4.0.0 to address Ruby 2.4.x issues:

roxml-3.3.1/lib/roxml/definition.rb:156: warning: constant ::Fixnum is deprecated

See https://github.com/ruckus/quickbooks-ruby/pull/410

* Add EffectiveTaxRate model (#408). Thank you @rudylee

## 0.5.1 (2017-07-17)

* Added purchase order to the list of batch request/response entities. Thank you @BitPerformanceLabs
* Added vendor to list of supported batch request entities. Thank you @BitPerformanceLabs

## 0.5.0 (2017-07-17)

* Added support for Line Extras and Name Values to Payment model. This is needed to read payments against invoices.

## 0.4.9 (2017-05-14)

* Adding journal enteries and spec to batch request and response - pull request #380 from nathan-mots/add-journal-entries-to-bulk - thank you!
* Add email send capability to SalesReceipt - pull request #376 from vanboom/sr_send - thank you!
* Improve consistency of email address setter method - pull request #377 from vanboom/375 - thank you!

## 0.4.8 (2017-03-14)

* Fixes from @cohendvir to resolve a regression in 0.4.7

## 0.4.7 (2017-03-07)

* add entity as reference - pull request #365 from @cohendvir - thank you!
* Add more exceptions for HTTP errors - pull request #364 from @drewish - thank you!
* Enhance the token renewal example - pull request #356 from @drewish - thank you!
* Fix bundler versioning -  pull request #357 from @drewish - thank you!
* Service.all returns nil if no elements exist, should return [] - pull request #358 from @vanboom - thank you!

* Lots of smaller fixes and cleanup from @drewish - thank you!

## 0.4.6 (2016-12-12)

* Add HomeBalance field to Invoice - thank you @mhssmnn
* Added exception handling for new 429 too many requests throttling. - thank you @stevedev
* Add ExchangeRate basic support - thank you @larissa
* Pass query params (e.g. requestid) with batch - thank you @drewish
* Support batch processing and change api of RefundReceipt - thank you @arthurchui
* Raise ThrottleExceeded when rate limited - thank you @drewish
* Add support for line item groups, aka: Bundle - thank you @florinpatrascu

## 0.4.4 (2016-06-02)

* Allow an invoice to be voided using only the Id and SyncToken - thank you @insphire
```ruby
# Both Invoice ID and SyncToken are required - you can either fetch an invoice to void or construct a new
# instance and specify those two parameters
invoice_service = Quickbooks::Service::Invoice.new(...)

# void from a fetched invoice
invoice = invoice_service.fetch_by_id(invoice_id)
invoice_service.void(invoice)

# or construct new instance with the required parameters
invoice = Quickbooks::Model::Invoice.new
invoice.id = 99
invoice.sync_token = 23
invoice_service.void(invoice)
```

* Add support for Change Data Capture: https://github.com/ruckus/quickbooks-ruby#change-data-capture - thank you @craggar

* Add time activity batch support - thank you @lmatiolis

## 0.4.3 (2016-02-13)

* Remove dependency on alias_method_chain from create_http_request method.
* Support for the Transfer endpoint - thanks @Craggar
* Added ability to download a Estimate PDF - thanks @rickbarrette

## 0.4.2 (2015-11-11)

* Fixed bug in Item#fetch_by_id where the minorversion param injection was generating an incorrect URL. Thanks to @jordangraft for the PR.

* Added helpers to ServiceCrud: all and find_by. Thanks to @vanboom for the PR.

* Added void method for service/payment. Thanks to @jordangraft for the PR.

## 0.4.1 (2015-10-28)

* Item service defaults to minorversion=4 for I/O operations

## 0.4.0 (2015-09-01)

* Reports API enhancements
* Tax Service with initial support for JSON. Tax Agency support and Tax Rate and update abilities.

## 0.3.0 (2015-08-12)

* Tax Service with initial support for JSON. Tax Agency support and Tax Rate creation and update abilities.
* Added support for specifying a RequestId for de-duplication
* Refactored Change Data Capture
* Added backwards compatibility to BaseReference initialize
* Changed the initialize method of BaseReference model and added support for the name/value attributes.

## 0.2.3 (2015-04-28)

* Reports. Merged PR #204 - thank you @raksonibs
* Parse the Fault element and surface the @element attribute - Merged PR #245 - thank you @arthurchui
* Surface a model Transaction Type and provide inquiry methods - Merged PR #246 - thank you @arthurchui

## 0.2.2 (2015-04-08)

* Fixed bug in attaching an upload to an entity. Merge pull request #239 from minimul/attach-ref. For attachable entity reference use base reference instead of entity reference
Thanks @minimum

* Ensure all models that have :line_items include the line-items initialization module. Addresses #232

## 0.2.1 (2015-03-25)

* Had to yank 0.2.0 due to a gemspec versioning issue.

## 0.2.0 (2015-03-25)

* Backwards Incompatible change: All `Id` attributes are parsed as strings. Previously they were parsed and cast as integer.
* Attachable service and model for uploading static files.

## 0.1.9 (2015-02-24)

* Merge pull request #222 from gouravmodi/master - Added CDC for Item

## 0.1.8 (2015-02-13)

* Merge pull request #221 from gouravmodi/master - Added support for Vendor Change Data Capture
* Merge pull request #210 from gherry/line-items - Add HasLineItem module to DRY transaction initialization
* Ensure line items initialization for Invoice, Bill, JournalEntry and Payment
* Add PurchaseTaxRateList to TaxCode
* Merge pull request #207 from gherry/master - Add ability to fetch PurchaseTaxRateList from TaxCode
* Namespace Validator class
* Merge pull request #201 from ahey/master - Add support for Invoice Change Data Capture
* Fix tax applicable on being interpreted as a date.
* Merge pull request #199 from rdeshpande/master - Adds support for CompanyInfo NameValue pairs
* Rename TaxIncluded to TaxInclusive for GlobalTaxCalculation.

## 0.1.7 (2014-10-29)

* Merge pull request #180 from arthurchui/error-401-403 - Added Quickbooks::Forbidden for HTTP 403

* Merge pull request #181 from benzittlau/master - Connect the params argument from fetch_by_id to do_http_get

## 0.1.6 (2014-10-23)

* Merge pull request #174 from arthurchui/sandbox-mode - allows for the specification of an alternate endpoints for Development / Production.
* Merge pull request #173 from michaelcheung/global_tax_calculation. Add global_tax_calculation to all transaction entities that use it.
* Merge pull request #169 from muhammad-abubakar/master. handle nil class error for linked_transaction in line.rb
* Merge pull request #167 from verifyvalid/master. added type to BaseReference
* Merge pull request #163 from arthurchui/fault-detail. Added Fault#detail

## 0.1.5 (2014-09-08)

* Merge pull request #162 from arthurchui/credit-memo-txn-date - thank you! Addresses the renaming of PlacedOn to TxnDate in CreditMemo
* Merge pull request #159 from minimul/je-spec - thank you! A more complete JournalEntry spec with proper setting of the line node
* Merge pull request #157 from michaelcheung/master - thank you! Add Payment entity to batch request and response
* Merge pull request #158 from minimul/tax-applicable-on
* Merge pull request #153 from jabr/add-class-to-time-activity - thank you! Add class ref to time activity model
* Merge pull request #156 from walter4dev/patch-1 - thank you! Update estimate.rb
* Merge pull request #155 from markrickert/query-in  - thank you! Better handling of IN queries in the query builder.
* Merge pull request #150 from arthurchui/master - thank you! QueryBuilder supports DateTime, Time and Date value
* Merge pull request #149 from arthurchui/master - thank you! Support to set invoice_id and credit_memo_id
* Merge pull request #148 from arthurchui/topic-147 - Fixed #147: initialized Payment#line_items as an empty array. Thank you!
* Merge pull request #145 from nickgervasi/master - thank you! EmployeeNumber can be a string

## 0.1.4 (2014-07-16)

* RefundReceipt support - thank you @n8armstrong
* Transaction level tax support for CreditMemos - thank you @minimul
* Broke out auto document numbering into a module - thank you @minimul
* Interface for query-in-batches - thank you @barelyknown
* PurchaseOrder deletion - thank you @barelyknown
* Enumerable-ize the Collection - thank you @mgates
* JournalEntry implementation - thank you @markrickert


## 0.1.3 (2014-05-13)

* Add AutoDocNumber support to SalesReceipt
* Ensure line items initialization when creating new SalesReceipt

## 0.1.2 (2014-03-26)

* Minor code cleanup
* Added more entities to BatchRequest/BatchResponse
* Implemented DiscountLineDetail for Invoices
* Ability to set DiscountLineDetail.discount_percent=nil to NOT include it in the XML

## 0.1.1 (2014-03-01)

* Batch Operations added - thank you @siliconsenthil

## 0.1.0 (2014-02-27)

* Refactored Boolean support - methods are now `foo?`. This was a backwards-incompatible change, thus
necessitating the version bump to 0.1.x.

* Tax entities added - thank you @harvesthq

## 0.0.8 (2014-02-21)

* Fixed bug where I had the wrong REST URL for Purchase Order.

## 0.0.7 (2014-02-20)

* Implemented `AccessToken` service with `renew` and `disconnect` methods for OAuth token management.

## 0.0.6 (2014-02-04)

* Upgraded nokogiri dependency to '~> 1.6', '>= 1.6.1'
* Added Account#{current_balance, current_balance_with_sub_accounts} properties - thanks to @diego-link-eggy
* Added support for Estimate, VendorCredit, PurchaseOrder, Bill, BillPayment entities - thanks to @sequielo
* Added support for Tax Lines in Purchases - thanks to @sequielo
* Added support for Term and Payment entities - thanks to @harvesthq
* Fixed issues with exception handling - thanks to @minimul

## 0.0.5 (2014-01-24)

* Fixed pagination bugs raised by @dlains - thank you.
* `Account.description` is not a required field
* Added `Employee` & `Vendor` Entity support via PR #23 & #21, thank you @minimul
* Updates to `CustomerMemo` and `PrivateNote` in `SalesReceipt`, via PR #22, thank you @seanxiesx

## 0.0.4 (2014-01-15)

* Added CompanyInfo model/service - thank you [Sean Xie](https://github.com/seanxiesx)

## 0.0.3 (2014-01-04)

* All reference types, e.g. Account#parent_ref are implemented via a first-class `BaseReference` instance.
Note: This is a backwards-incompatible change and any existing usages of setting a reference type directly, e.g.

```ruby
account = Quickbooks::Model::Account.new
account.parent_ref = 2
```

The above will fail. The correct usage is now:

```ruby
account = Quickbooks::Model::Account.new
account.parent_id = 2
```

The `_id=` setter will automatically create an instance of the appropriate `ParentRef` in this case.

## 0.0.2 (2013-11-18)

* Sorry, I forgot what was in this release.

## 0.0.1 (2013-11-15)

* Initial Release

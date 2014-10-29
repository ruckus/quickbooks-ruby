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

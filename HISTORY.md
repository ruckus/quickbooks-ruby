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
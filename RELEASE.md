## How to Release

* Bump version number in `lib/quickbooks/version.rb`
* Document changes in `HISTORY.md`
* Run `gem release quickbooks-ruby.gemspec` -- requires the `gem-release` gem

* Tag the release
  $ git tag -a v0.5.0 -m "0.5.0"

* Push with tags
git push origin --tags

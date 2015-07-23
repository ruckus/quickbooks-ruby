module FixtureHelpers
  def fixture_path
    File.expand_path("../../fixtures", __FILE__)
  end

  def fixture(file)
    File.new(fixture_path + '/' + file).read
  end

  def json_fixture(file)
    File.new("#{fixture_path}/json/#{file.to_s}.json").read
  end

end

RSpec.configure do |config|
  config.include(FixtureHelpers)
end

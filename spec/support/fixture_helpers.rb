module FixtureHelpers
  def fixture_path
    File.expand_path("../../fixtures", __FILE__)
  end

  def fixture(file)
    File.new(fixture_path + '/' + file).read
  end

end

RSpec.configure do |config|
  config.include(FixtureHelpers)
end

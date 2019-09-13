describe "Quickbooks::Service::ExchangeRate" do
  before(:all) { construct_service :exchange_rate }

  it "can query exchange rates" do
    stub_http_request(:get,
                 @service.url_for_query,
                 ["200", "OK"],
                 fixture("exchange_rates.xml"))

    exchange_rates = @service.query

    exchange_rates.entries.count.should eq(1)
    exchange_rates.entries.first.source_currency_code.should eq("EUR")
    exchange_rates.entries.first.target_currency_code.should eq("USD")
    exchange_rates.entries.first.rate.should eq(2.5)
  end

  it "can query exchange rates by currency" do
    model = Quickbooks::Model::ExchangeRate
    stub_http_request(:get,
                 "#{@service.url_for_resource(model::REST_RESOURCE)}?sourcecurrencycode=EUR",
                 ["200", "OK"],
                 fixture("exchange_rate_by_currency.xml"))

    exchange_rate = @service.fetch_by_currency('EUR')

    exchange_rate.source_currency_code.should eq("EUR")
    exchange_rate.target_currency_code.should eq("USD")
    exchange_rate.rate.should eq(2.5)
  end
end

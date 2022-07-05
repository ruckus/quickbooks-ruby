describe "Quickbooks::Service::ExchangeRate" do
  before(:all) { construct_service :exchange_rate }

  it "can query exchange rates" do
    stub_http_request(:get,
                 @service.url_for_query,
                 ["200", "OK"],
                 fixture("exchange_rates.xml"))

    exchange_rates = @service.query

    expect(exchange_rates.entries.count).to eq(1)
    expect(exchange_rates.entries.first.source_currency_code).to eq("EUR")
    expect(exchange_rates.entries.first.target_currency_code).to eq("USD")
    expect(exchange_rates.entries.first.rate).to eq(2.5)
  end

  it "can query exchange rates by currency" do
    model = Quickbooks::Model::ExchangeRate
    stub_http_request(:get,
                 "#{@service.url_for_resource(model::REST_RESOURCE)}?sourcecurrencycode=EUR",
                 ["200", "OK"],
                 fixture("exchange_rate_by_currency.xml"))

    exchange_rate = @service.fetch_by_currency('EUR')

    expect(exchange_rate.source_currency_code).to eq("EUR")
    expect(exchange_rate.target_currency_code).to eq("USD")
    expect(exchange_rate.rate).to eq(2.5)
  end
end

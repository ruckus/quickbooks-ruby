describe Quickbooks::Util::QueryBuilder do
  it "can escape a single-quoted query" do
    expected = "DisplayName LIKE '%O\\'Halloran'"
    generated = subject.clause("DisplayName", "LIKE", "%O'Halloran")
    expect(expected).to eq generated
  end

  it "parses a Time value to the required format" do
    time = Time.new(2014, 10, 31, 2, 2, 2, "+00:00")
    expected = "Metadata.LastUpdatedTime > '#{time.iso8601}'"
    generated = subject.clause("Metadata.LastUpdatedTime", ">", time)
    expect(expected).to eq generated
  end

  it "parses a Date value the required format" do
    date = Date.new(2014)
    expected = "DueDate > '#{date.strftime('%Y-%m-%d')}'"
    generated = subject.clause("DueDate", ">", date)
    expect(expected).to eq generated
  end

  it "parses an IN query with an array of values" do
    values = [10, 20, "something", "40", "it's a quote!"]
    expected = "DocNumber IN ('10', '20', 'something', '40', 'it\\'s a quote!')"
    generated = subject.clause("DocNumber", "IN", values)
    expect(expected).to eq generated
  end
end

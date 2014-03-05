describe Quickbooks::Util::QueryBuilder do
  it "can escape a single-quoted query" do
    util = Quickbooks::Util::QueryBuilder.new
    expected = "DisplayName LIKE '%O\\'Halloran'"
    generated = util.clause("DisplayName", "LIKE", "%O'Halloran")
    expected.should == generated
  end
end
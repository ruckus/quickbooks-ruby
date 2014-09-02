require 'nokogiri'

describe "Quickbooks::Model::JournalEntry" do

  it "validates basic setup" do
    je = Quickbooks::Model::JournalEntry.new
    je.line_items = []
    jel = Quickbooks::Model::JournalEntryLineDetail.new  
    jel.posting_type = "Credit"
    jel.tax_code_id = 2
    jel.tax_applicable_on = "Credit"
    jel.account_id = 1
    je.line_items << jel
    je.valid?.should be_true
  end
end

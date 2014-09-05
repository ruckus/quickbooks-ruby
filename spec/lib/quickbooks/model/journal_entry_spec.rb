require 'nokogiri'

describe "Quickbooks::Model::JournalEntry" do

  it "validates basic setup" do
    je = Quickbooks::Model::JournalEntry.new
    je.line_items = []
    line_item             = Quickbooks::Model::Line.new
    line_item.description = 'Received Payment'
    line_item.amount      = 148.99
    line_item.detail_type = 'JournalEntryLineDetail'
    jel = Quickbooks::Model::JournalEntryLineDetail.new  
    jel.posting_type = 'Credit'
    jel.tax_code_id = 2
    jel.tax_applicable_on = 'Purchased'
    jel.account_id = 1
    line_item.journal_entry_line_detail = jel
    je.line_items << line_item
    n = Nokogiri::XML(je.to_xml.to_s)
    n.at_css('JournalEntry > Line > Description').content.should == 'Received Payment'
    n.at_css('Line > JournalEntryLineDetail > TaxCodeRef').content.should == '2'
    je.valid?.should be_true
  end

  it "can support either :tax_applicable_on or :tax_applicable" do
    jel = Quickbooks::Model::JournalEntryLineDetail.new
    jel.stub(:description).and_return('Desc 1') # There is not xml_accessor for description on JournalEntryLineDetail?
    jel.posting_type = 'Credit'
    jel.tax_code_id = 2
    jel.tax_applicable_on = nil
    jel.tax_applicable = 'Purchased'
    jel.account_id = 1
    jel.errors.messages.include?(:tax_applicable_on).should be_false
  end
end

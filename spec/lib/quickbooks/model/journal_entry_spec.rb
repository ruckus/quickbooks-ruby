require 'nokogiri'

describe "Quickbooks::Model::JournalEntry" do

  it "validates basic setup" do
    je = Quickbooks::Model::JournalEntry.new
    line_item = Quickbooks::Model::Line.new
    line_item.description = 'Received Payment'
    line_item.amount      = 148.99
    line_item.detail_type = 'JournalEntryLineDetail'
    jel = Quickbooks::Model::JournalEntryLineDetail.new
    jel.posting_type = 'Credit'
    jel.tax_code_id = 2
    jel.tax_applicable_on = 'Credit'
    jel.account_id = 1
    line_item.journal_entry_line_detail = jel
    je.line_items << line_item
    n = Nokogiri::XML(je.to_xml.to_s)
    n.at('JournalEntry > Line > Description').content.should == 'Received Payment'
    n.at('Line > JournalEntryLineDetail > TaxCodeRef').content.should == '2'
    je.valid?.should be_true
  end

  it 'creates an entity reference' do
    je = Quickbooks::Model::JournalEntry.new
    line_item = Quickbooks::Model::Line.new
    jel = Quickbooks::Model::JournalEntryLineDetail.new
    entity = Quickbooks::Model::Entity.new
    entity.type = 'Customer'
    entity_ref = Quickbooks::Model::BaseReference.new(1)
    entity_ref.name = 'James Rockenstall'
    entity.entity_ref = entity_ref
    jel.entity = entity
    line_item.journal_entry_line_detail = jel
    je.line_items << line_item
    n = Nokogiri::XML(je.to_xml.to_s)
    n.at('Line > JournalEntryLineDetail > Entity > Type').content.should == 'Customer'
    n.at('JournalEntryLineDetail > Entity > EntityRef').content.should == '1'
    n.at('JournalEntryLineDetail > Entity > EntityRef')[:name].should == 'James Rockenstall'
  end

  it "parse from XML" do
    xml = fixture("journal_entry.xml")
    item = Quickbooks::Model::JournalEntry.from_xml(xml)
    item.id.should == "450"
  end
end

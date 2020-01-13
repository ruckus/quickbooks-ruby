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
    expect(n.at('JournalEntry > Line > Description').content).to eq('Received Payment')
    expect(n.at('Line > JournalEntryLineDetail > TaxCodeRef').content).to eq('2')
    expect(je.valid?).to be true
  end

  it 'creates an entity reference' do
    je = Quickbooks::Model::JournalEntry.new
    line_item = Quickbooks::Model::Line.new
    jel = Quickbooks::Model::JournalEntryLineDetail.new
    entity = Quickbooks::Model::Entity.new
    entity.type = 'Customer'
    entity_ref = Quickbooks::Model::BaseReference.new(1, name: 'James Rockenstall')
    entity.entity_ref = entity_ref
    jel.entity = entity
    line_item.journal_entry_line_detail = jel
    je.line_items << line_item
    n = Nokogiri::XML(je.to_xml.to_s)
    expect(n.at('Line > JournalEntryLineDetail > Entity > Type').content).to eq('Customer')
    expect(n.at('JournalEntryLineDetail > Entity > EntityRef').content).to eq('1')
    expect(n.at('JournalEntryLineDetail > Entity > EntityRef')[:name]).to eq('James Rockenstall')
  end

  it "parse from XML" do
    xml = fixture("journal_entry.xml")
    item = Quickbooks::Model::JournalEntry.from_xml(xml)
    expect(item.id).to eq("450")
  end
end

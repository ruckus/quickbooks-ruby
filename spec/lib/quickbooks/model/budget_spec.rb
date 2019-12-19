describe "Quickbooks::Model::Budget" do

  it "parse from XML" do
    xml = fixture("budget.xml")
    budget = Quickbooks::Model::Budget.from_xml(xml)

    expect(budget.sync_token).to eq(1)
    expect(budget.active?).to be true
    expect(budget.line_items.count).to eq 192


    line1 = budget.line_items[0]
    expect(line1.date).to eq Date.parse("2015-01-01")
    expect(line1.amount).to eq '0'
    expect(line1.account_ref.value).to eq '14'
    expect(line1.account_ref.name).to eq 'Miscellaneous'

    line2 = budget.line_items[23]
    expect(line2.date).to eq Date.parse("2015-12-01")
    expect(line2.amount).to eq '475.00'
    expect(line2.account_ref.value).to eq '45'
    expect(line2.account_ref.name).to eq 'Landscaping Services'
  end

end

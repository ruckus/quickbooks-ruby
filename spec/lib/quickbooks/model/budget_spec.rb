describe "Quickbooks::Model::Budget" do

  it "parse from XML" do
    xml = fixture("budget.xml")
    budget = Quickbooks::Model::Budget.from_xml(xml)

    budget.sync_token.should == 1
    budget.active.should == 'true'
    budget.line_items.count.should == 192

    line1 = budget.line_items[0]
    line1.date.should == Date.parse("2015-01-01")
    line1.amount.should == '0'
    line1.account_ref.value.should == '14'
    line1.account_ref.name.should == 'Miscellaneous'

    line2 = budget.line_items[23]
    line2.date.should == Date.parse("2015-12-01")
    line2.amount.should == '475.00'
    line2.account_ref.value.should == '45'
    line2.account_ref.name.should == 'Landscaping Services'
  end

end

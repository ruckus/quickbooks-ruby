describe "Quickbooks::Model::Item" do

  it "parse from XML" do
    xml = fixture("item.xml")
    item = Quickbooks::Model::Item.from_xml(xml)
    item.id.should == 2
    item.sync_token.should == 0
    item.meta_data.should_not be_nil
    item.name.should == 'Plush Baby Doll'
    item.description.should == 'A fine baby doll - in many colors'
    item.active?.should == true
    item.taxable?.should == false
    item.unit_price.should == 50
    item.type.should == 'Service'
    item.income_account_ref.to_i.should == 1
    item.purchase_cost.should == 0
    item.track_quantity_on_hand?.should == false
  end

  it "must have a name for create / update" do
    item = Quickbooks::Model::Item.new
    item.valid?.should == false
    item.errors.keys.include?(:name).should == true

    # now give it a name
    item.name = "Water Slide"
    item.valid?
    item.errors.keys.include?(:name).should_not == true
  end

  it "doesn't set rate_percent unless user explicitly does it" do
    item = Quickbooks::Model::Item.new
    item.name = "Name name name!"
    item.unit_price = 22
    expect(item.to_xml.elements.map(&:name)).not_to include("RatePercent")

    item.rate_percent = 5
    expect(item.to_xml.elements.map(&:name)).to include("RatePercent")
  end

  it "type must be known" do
    item = Quickbooks::Model::Item.new

    # an invalid type ...
    item.type = 'Unknown'
    item.valid?.should == false
    item.errors.keys.include?(:type).should == true

    # an valid type ...
    item.type = Quickbooks::Model::Item::INVENTORY_TYPE
    item.valid?
    item.errors.keys.include?(:type).should_not == true
  end
end

describe "Quickbooks::Model::Item" do

  it "parse from XML" do
    xml = fixture("item.xml")
    item = Quickbooks::Model::Item.from_xml(xml)
    expect(item.id).to eq("2")
    expect(item.sync_token).to eq(0)
    expect(item.meta_data).not_to be_nil
    expect(item.name).to eq('Plush Baby Doll')
    expect(item.sku).to eq('PBD01')
    expect(item.description).to eq('A fine baby doll - in many colors')
    expect(item.active?).to eq(true)
    expect(item.taxable?).to eq(false)
    expect(item.unit_price).to eq(50)
    expect(item.type).to eq('Service')
    expect(item.income_account_ref.to_i).to eq(1)
    expect(item.purchase_cost).to eq(0)
    expect(item.track_quantity_on_hand?).to eq(false)
  end

  it "must have a name for create / update" do
    item = Quickbooks::Model::Item.new
    expect(item.valid?).to eq(false)
    expect(item.errors.keys.include?(:name)).to eq(true)

    # now give it a name
    item.name = "Water Slide"
    item.valid?
    expect(item.errors.keys.include?(:name)).not_to eq(true)
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
    expect(item.valid?).to eq(false)
    expect(item.errors.keys.include?(:type)).to eq(true)

    # an valid type ...
    item.type = Quickbooks::Model::Item::INVENTORY_TYPE
    item.valid?
    expect(item.errors.keys.include?(:type)).not_to eq(true)
  end
end

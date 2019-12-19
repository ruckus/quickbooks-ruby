describe "Quickbooks::Model::Class" do

  it "parse from XML" do
    xml = fixture("class.xml")
    classs = Quickbooks::Model::Class.from_xml(xml)
    expect(classs.sync_token).to eq 1
    expect(classs.name).to eq 'Design'
    expect(classs.sub_class?).to eq false
    expect(classs.fully_qualified_name).to eq 'Design'
    expect(classs.active?).to eq true
  end

  it "can't assign a bad name" do
    classs = Quickbooks::Model::Class.new
    classs.name = "My:Class"
    expect(classs.valid?).to eq false
    expect(classs.errors.keys).to include(:name)
  end

  it "cannot update an invalid model" do
    classs = Quickbooks::Model::Class.new
    expect(classs.valid_for_update?).to eq false
    expect(classs.to_xml_ns).to match('Class')
    expect(classs.errors.keys).to include(:sync_token)
  end

end

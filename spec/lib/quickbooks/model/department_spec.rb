describe "Quickbooks::Model::Department" do

  it "parse from XML" do
    xml = fixture("department.xml")
    department = Quickbooks::Model::Department.from_xml(xml)
    expect(department.sync_token).to eq(0)
    expect(department.name).to eq('Sales Department')
    expect(department.sub_department?).to eq(false)
    expect(department.fully_qualified_name).to eq('Sales Department')
    expect(department.active?).to eq(true)
  end

  it "can't assign a bad name" do
    department = Quickbooks::Model::Department.new
    department.name = "This:Department"
    department.valid?
    expect(department.errors.keys).to include(:name)
  end

  it "cannot update an invalid model" do
    department = Quickbooks::Model::Department.new
    expect(department.valid_for_update?).to eq(false)
    expect(department.to_xml_ns).to match('Department')
    expect(department.errors.keys).to include(:sync_token)
  end

end

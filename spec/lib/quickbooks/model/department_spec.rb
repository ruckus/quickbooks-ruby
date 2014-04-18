describe "Quickbooks::Model::Department" do

  it "parse from XML" do
    xml = fixture("department.xml")
    department = Quickbooks::Model::Department.from_xml(xml)
    department.sync_token.should == 0
    department.name.should == 'Sales Department'
    department.sub_department?.should == false
    department.fully_qualified_name.should == 'Sales Department'
    department.active?.should == true
  end

  it "can't assign a bad name" do
    department = Quickbooks::Model::Department.new
    department.name = "This:Department"
    department.valid?
    department.errors.keys.should include(:name)
  end

  it "cannot update an invalid model" do
    department = Quickbooks::Model::Department.new
    department.valid_for_update?.should == false
    department.to_xml_ns.should match('Department')
    department.errors.keys.should include(:sync_token)
  end

end

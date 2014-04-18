describe "Quickbooks::Model::Class" do

  it "parse from XML" do
    xml = fixture("class.xml")
    classs = Quickbooks::Model::Class.from_xml(xml)
    classs.sync_token.should == 1
    classs.name.should == 'Design'
    classs.sub_class?.should == false
    classs.fully_qualified_name.should == 'Design'
    classs.active?.should == true
  end

  it "can't assign a bad name" do
    classs = Quickbooks::Model::Class.new
    classs.name = "My:Class"
    classs.valid?
    classs.errors.keys.should include(:name)
  end

  it "cannot update an invalid model" do
    classs = Quickbooks::Model::Class.new
    classs.valid_for_update?.should == false
    classs.to_xml_ns.should match('Class')
    classs.errors.keys.should include(:sync_token)
  end

end

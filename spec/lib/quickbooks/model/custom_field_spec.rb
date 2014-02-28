describe "Quickbooks::Model::CustomField" do

  it "parse from XML as String" do
    xml = fixture("custom_field_string.xml")
    field = Quickbooks::Model::CustomField.from_xml(xml)
    field.name.should == "SalesAssociate"
    field.type.should == "StringType"
    field.string_value.should == "Miller"
  end

  it "parse from XML as Date" do
    xml = fixture("custom_field_date.xml")
    field = Quickbooks::Model::CustomField.from_xml(xml)
    field.name.should == "LastUpdated"
    field.type.should == "DateType"
    field.date_value.should == Date.civil(2013, 4, 4)
  end

  it "parse from XML as Number" do
    xml = fixture("custom_field_number.xml")
    field = Quickbooks::Model::CustomField.from_xml(xml)
    field.name.should == "NumberOfWatermelons"
    field.type.should == "NumberType"
    field.number_value.should == 43
  end

end
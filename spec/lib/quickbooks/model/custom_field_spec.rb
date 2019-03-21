describe "Quickbooks::Model::CustomField" do

  let(:field) { Quickbooks::Model::CustomField.from_xml(field_xml) }

  describe "String" do
    let(:field_xml) { fixture("custom_field_string.xml") }

    it "parse from XML as String" do
      field.name.should == "SalesAssociate"
      field.type.should == "StringType"
      field.string_value.should == "Miller"
      field.value.should == field.string_value
    end

    it "should set value" do
      field.value = "Changed"
      field.string_value.should == "Changed"
    end
  end

  describe "Date" do
    let(:field_xml) { fixture("custom_field_date.xml") }
    it "parse from XML as Date" do
      field.name.should == "LastUpdated"
      field.type.should == "DateType"
      field.date_value.should == Date.civil(2013, 4, 4)
      field.value.should == field.date_value
    end

    it "should set value" do
      field.value = Date.civil(2019, 3, 15)
      field.date_value.should == Date.civil(2019, 3, 15)
    end
  end

  describe "Number" do
    let(:field_xml) { fixture("custom_field_number.xml") }

    it "parse from XML as Number" do
      field.name.should == "NumberOfWatermelons"
      field.type.should == "NumberType"
      field.number_value.should == 43
      field.value.should == field.number_value
    end

    it "should set value" do
      field.value = 99
      field.number_value.should == 99
    end
  end

  describe "Boolean" do
    let(:field_xml) { fixture("custom_field_boolean.xml") }

    it "parse from XML as Boolean" do
      field.name.should == "MyBoolean"
      field.type.should == "BooleanType"
      field.boolean_value.should == 'true'
      field.value.should == true
    end

    it "should set value" do
      field.value = false
      field.boolean_value.should == 'false'

      field.value = true
      field.boolean_value.should == 'true'
    end
  end
end
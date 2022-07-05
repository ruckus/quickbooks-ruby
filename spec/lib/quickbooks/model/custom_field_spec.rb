describe "Quickbooks::Model::CustomField" do

  let(:field) { Quickbooks::Model::CustomField.from_xml(field_xml) }

  describe "String" do
    let(:field_xml) { fixture("custom_field_string.xml") }

    it "parse from XML as String" do
      expect(field.name).to eq("SalesAssociate")
      expect(field.type).to eq("StringType")
      expect(field.string_value).to eq("Miller")
      expect(field.value).to eq(field.string_value)
    end

    it "should set value" do
      field.value = "Changed"
      expect(field.string_value).to eq("Changed")
    end
  end

  describe "Date" do
    let(:field_xml) { fixture("custom_field_date.xml") }
    it "parse from XML as Date" do
      expect(field.name).to eq("LastUpdated")
      expect(field.type).to eq("DateType")
      expect(field.date_value).to eq(Date.civil(2013, 4, 4))
      expect(field.value).to eq(field.date_value)
    end

    it "should set value" do
      field.value = Date.civil(2019, 3, 15)
      expect(field.date_value).to eq(Date.civil(2019, 3, 15))
    end
  end

  describe "Number" do
    let(:field_xml) { fixture("custom_field_number.xml") }

    it "parse from XML as Number" do
      expect(field.name).to eq("NumberOfWatermelons")
      expect(field.type).to eq("NumberType")
      expect(field.number_value).to eq(43)
      expect(field.value).to eq(field.number_value)
    end

    it "should set value" do
      field.value = 99
      expect(field.number_value).to eq(99)
    end
  end

  describe "Boolean" do
    let(:field_xml) { fixture("custom_field_boolean.xml") }

    it "parse from XML as Boolean" do
      expect(field.name).to eq("MyBoolean")
      expect(field.type).to eq("BooleanType")
      expect(field.boolean_value).to eq('true')
      expect(field.value).to eq(true)
    end

    it "should set value" do
      field.value = false
      expect(field.boolean_value).to eq('false')

      field.value = true
      expect(field.boolean_value).to eq('true')
    end
  end
end
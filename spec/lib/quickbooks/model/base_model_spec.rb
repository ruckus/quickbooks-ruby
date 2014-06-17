describe "Quickbooks::Model::BaseModel" do
  module Quickbooks::Model
    class BarModel < BaseModel
      XML_NODE = "Bar"
      xml_accessor :foo, :from => "foo", :as => Integer
    end

    class FooModel < BaseModel
      XML_NODE = "Foo"
      xml_accessor :baz, :from => "baz"
      xml_accessor :bar, :from => "bar", :as => BarModel
      xml_accessor :amount, :from => "amount", :as => BigDecimal, :to_xml => to_xml_big_decimal
    end
  end

  let(:bar_model) { Quickbooks::Model::BarModel.from_xml "<Bar><foo>42</foo></Bar>" }
  let(:foo_model) { Quickbooks::Model::FooModel.from_xml <<-XML }
<Foo><baz>quux</baz><bar><foo>42</foo></bar></Foo>
  XML

  describe ".new" do
    it "allows attributes to be passed in" do
      Quickbooks::Model::FooModel.new(:baz => "value").baz.should eq("value")
    end
  end

  describe ".attribute_names" do
    it "returns the list of attribute names" do
      Quickbooks::Model::FooModel.attribute_names.should eq(%w{baz bar amount})
      Quickbooks::Model::BarModel.attribute_names.should eq(%w{foo})
    end
  end

  describe ".to_xml_big_decimal" do
    it "only sets value when present" do
      foo = Quickbooks::Model::FooModel.new
      foo.to_xml
      expect(foo.to_xml.elements.map(&:name)).not_to include("amount")

      foo.amount = 3
      expect(foo.to_xml.elements.map(&:name)).to include("amount")
    end
  end

  describe "#attributes" do
    it "returns a hash of attribute names and values" do
      bar_model.attributes.should eq("foo" => 42)
    end

    it "returns a hash even for nested objects" do
      foo_model.attributes.should eq("baz" => "quux", "bar" => {"foo" => 42}, "amount" => nil)
    end
  end

  describe "#[]" do
    it "delegates to the underlying attributes" do
      bar_model[:foo].should eq(42)
    end
  end

  describe "#fetch" do
    it "delegates to the underlying attributes" do
      bar_model.fetch(:foo).should eq(42)
    end
  end


  describe ".inspect" do
    it "should include the class name" do
       Quickbooks::Model::FooModel.inspect.should match /\AQuickbooks::Model::FooModel/
    end
    it "should include the attribute keys" do
      Quickbooks::Model::FooModel.inspect.should match /baz/
    end
    it "should include the attribute types" do
      Quickbooks::Model::FooModel.inspect.should match /amount:BigDecimal/
    end
    it "should include the association type" do
      Quickbooks::Model::FooModel.inspect.should match /bar:.+:Quickbooks::Model::BarModel/
    end
  end

  describe "#inspect" do
    it "should include the class name" do
      foo_model.inspect.should match /\A#<Quickbooks::Model::FooModel.*>/
    end
    it "should include the attribute keys" do
      foo_model.inspect.should match /baz/
    end
    it "should have nil values on init" do
      Quickbooks::Model::FooModel.new.inspect.should match /baz: nil/
    end
    it "should show values if they are there" do
      foo_model.inspect.should match /baz: quux/
    end
  end

end

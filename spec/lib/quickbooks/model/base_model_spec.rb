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
      Quickbooks::Model::FooModel.attribute_names.should eq(%w{baz bar})
      Quickbooks::Model::BarModel.attribute_names.should eq(%w{foo})
    end
  end

  describe "#attributes" do
    it "returns a hash of attribute names and values" do
      bar_model.attributes.should eq("foo" => 42)
    end

    it "returns a hash even for nested objects" do
      foo_model.attributes.should eq("baz" => "quux", "bar" => {"foo" => 42})
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
end

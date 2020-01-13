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

  context "definition" do
    subject { Quickbooks::Model::FooModel.new }

    context "For a non-transaction entity" do
      describe '#is_transaction_entity?' do
        subject { super().is_transaction_entity? }
        it { is_expected.to be false }
      end

      describe '#is_name_list_entity?' do
        subject { super().is_name_list_entity? }
        it { is_expected.to be true }
      end
    end

    context "For a transaction entity" do
      before do
        expect(Quickbooks::Model::Definition::ClassMethods::TRANSACTION_ENTITIES).to receive(:include?).and_return(true)
      end

      describe '#is_transaction_entity?' do
        subject { super().is_transaction_entity? }
        it { is_expected.to be true }
      end

      describe '#is_name_list_entity?' do
        subject { super().is_name_list_entity? }
        it { is_expected.to be false }
      end
    end
  end

  describe ".new" do
    it "allows attributes to be passed in" do
      expect(Quickbooks::Model::FooModel.new(:baz => "value").baz).to eq("value")
    end
  end

  describe ".attribute_names" do
    it "returns the list of attribute names" do
      expect(Quickbooks::Model::FooModel.attribute_names).to eq(%w{baz bar amount})
      expect(Quickbooks::Model::BarModel.attribute_names).to eq(%w{foo})
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
      expect(bar_model.attributes).to eq("foo" => 42)
    end

    it "returns a hash even for nested objects" do
      expect(foo_model.attributes).to eq("baz" => "quux", "bar" => {"foo" => 42}, "amount" => nil)
    end
  end

  describe "#[]" do
    it "delegates to the underlying attributes" do
      expect(bar_model[:foo]).to eq(42)
    end
  end

  describe "#fetch" do
    it "delegates to the underlying attributes" do
      expect(bar_model.fetch(:foo)).to eq(42)
    end
  end


  describe ".inspect" do
    it "should include the class name" do
       expect(Quickbooks::Model::FooModel.inspect).to match /\AQuickbooks::Model::FooModel/
    end
    it "should include the attribute keys" do
      expect(Quickbooks::Model::FooModel.inspect).to match /baz/
    end
    it "should include the attribute types" do
      expect(Quickbooks::Model::FooModel.inspect).to match /amount:BigDecimal/
    end
    it "should include the association type" do
      expect(Quickbooks::Model::FooModel.inspect).to match /bar:.+:Quickbooks::Model::BarModel/
    end
  end

  describe "#inspect" do
    it "should include the class name" do
      expect(foo_model.inspect).to match /\A#<Quickbooks::Model::FooModel.*>/
    end
    it "should include the attribute keys" do
      expect(foo_model.inspect).to match /baz/
    end
    it "should have nil values on init" do
      expect(Quickbooks::Model::FooModel.new.inspect).to match /baz: nil/
    end
    it "should show values if they are there" do
      expect(foo_model.inspect).to match /baz: quux/
    end
  end

end

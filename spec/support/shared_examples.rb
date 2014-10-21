
shared_examples_for "a model that has auto_doc_number support" do |entity|
  let(:model) { "Quickbooks::Model::#{entity}".constantize.new }

  it "turned on should set the AutoDocNumber tag" do
    invoice = model
    invoice.auto_doc_number!
    invoice.to_xml.to_s.should =~ /AutoDocNumber/
  end

  it "turned on then doc_number should not be specified" do
    invoice = model 
    invoice.doc_number = 'AUTO'
    invoice.auto_doc_number!
    invoice.valid?
    invoice.valid?.should == false
    invoice.errors.keys.include?(:doc_number).should be_true
  end

  it "turned off then doc_number can be specified" do
    invoice = model
    invoice.doc_number = 'AUTO'
    invoice.valid?
    invoice.errors.keys.include?(:doc_number).should be_false
  end
end

shared_examples_for "a model with a valid GlobalTaxCalculation" do |value|
  before { subject.global_tax_calculation = value }
  it "does not include an error for global_tax_calculation" do
    subject.valid?
    subject.errors.keys.include?(:global_tax_calculation).should be_false
  end
end

shared_examples_for "a model with an invalid GlobalTaxCalculation" do
  before { subject.global_tax_calculation = "Invalid" }
  it "includes an error for global_tax_calculation" do
    subject.valid?.should be_false
    subject.errors.keys.include?(:global_tax_calculation).should be_true
  end
end

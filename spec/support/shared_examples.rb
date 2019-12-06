
shared_examples_for "a model that has auto_doc_number support" do |entity|
  let(:model) { "Quickbooks::Model::#{entity}".constantize.new }

  it "turned on should set the AutoDocNumber tag" do
    invoice = model
    invoice.auto_doc_number!
    expect(invoice.to_xml.to_s).to match(/AutoDocNumber/)
  end

  it "turned on then doc_number should not be specified" do
    invoice = model
    invoice.doc_number = 'AUTO'
    invoice.auto_doc_number!
    invoice.valid?
    expect(invoice.valid?).to be false
    expect(invoice.errors.keys.include?(:doc_number)).to be true
  end

  it "turned off then doc_number can be specified" do
    invoice = model
    invoice.doc_number = 'AUTO'
    invoice.valid?
    expect(invoice.errors.keys.include?(:doc_number)).to be false
  end
end

shared_examples_for "a model with a valid GlobalTaxCalculation" do |value|
  before { subject.global_tax_calculation = value }
  it "does not include an error for global_tax_calculation" do
    subject.valid?
    expect(subject.errors.keys.include?(:global_tax_calculation)).to be false
  end
end

shared_examples_for "a model with an invalid GlobalTaxCalculation" do
  before { subject.global_tax_calculation = "Invalid" }
  it "includes an error for global_tax_calculation" do
    expect(subject.valid?).to be false
    expect(subject.errors.keys.include?(:global_tax_calculation)).to be true
  end
end

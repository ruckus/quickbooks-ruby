
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

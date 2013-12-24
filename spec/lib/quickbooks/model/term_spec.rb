describe "Quickbooks::Model::Term" do

  it "parse from XML" do
    xml = fixture("term.xml")
    term = Quickbooks::Model::Term.from_xml(xml)
    term.sync_token.should == 2

    term.meta_data.should_not be_nil

    term.customer_ref.value.should == "2"
    term.customer_ref.name.should == "Sunset Bakery"
  end


  it "should require customer_ref for create / update" do
    term = Quickbooks::Model::Term.new
    term.valid?.should == true
    term.errors.keys.include?(:customer_ref).should == false
  end
  
end

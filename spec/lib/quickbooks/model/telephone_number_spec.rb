describe "Quickbooks::Model::TelephoneNumber" do

  it "can be initialized with a number" do
    number = "415-555-1212"
    tel = Quickbooks::Model::TelephoneNumber.new(number)
    tel.free_form_number.should == number
  end

end

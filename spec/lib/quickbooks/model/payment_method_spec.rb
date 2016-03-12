describe Quickbooks::Model::PaymentMethod do
  it "must have a valid type if defined" do
    account = Quickbooks::Model::PaymentMethod.new

    # It should allow nil
    account.valid?
    account.errors.keys.include?(:type).should == false

    account.type = 'Undocummented Type'
    account.valid?
    account.errors.keys.include?(:type).should == true

    account.type = Quickbooks::Model::PaymentMethod::CREDIT_CARD
    account.valid?
    account.errors.keys.include?(:type).should == false
  end
end

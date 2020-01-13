describe Quickbooks::Model::PaymentMethod do
  it "must have a valid type if defined" do
    account = Quickbooks::Model::PaymentMethod.new

    # It should allow nil
    account.valid?
    expect(account.errors.keys.include?(:type)).to eq(false)

    account.type = 'Undocummented Type'
    account.valid?
    expect(account.errors.keys.include?(:type)).to eq(true)

    account.type = Quickbooks::Model::PaymentMethod::CREDIT_CARD
    account.valid?
    expect(account.errors.keys.include?(:type)).to eq(false)
  end
end

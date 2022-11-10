describe Quickbooks::Model::Account do
  it "must have a name for create / update" do
    account = Quickbooks::Model::Account.new
    account.valid?
    expect(account.errors.map(&:attribute).include?(:name)).to be true

    account.name = Array.new(102).join("a") # 101 character, too long
    account.valid?
    expect(account.errors.map(&:attribute).include?(:name)).to be true

    account.name = "Invalid name with :"
    account.valid?
    expect(account.errors.map(&:attribute).include?(:name)).to be true

    account.name = "Invalid name with \""
    account.valid?
    expect(account.errors.map(&:attribute).include?(:name)).to be true

    account.name = "Regular"
    account.valid?
    expect(account.errors.map(&:attribute).include?(:name)).to be false
  end

  it "must have a classifiction" do
    account = Quickbooks::Model::Account.new
    account.valid?
    expect(account.errors.map(&:attribute).include?(:classification)).to be true

    account.classification = 'Undocummented Classification'
    account.valid?
    expect(account.errors.map(&:attribute).include?(:classification)).to be true

    account.classification = Quickbooks::Model::Account::LIABILITY
    account.valid?
    expect(account.errors.map(&:attribute).include?(:classification)).to be false
  end
end

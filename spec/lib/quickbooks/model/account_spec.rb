describe Quickbooks::Model::Account do
  it "must have a name for create / update" do
    account = Quickbooks::Model::Account.new
    account.valid?
    account.errors.keys.include?(:name).should == true

    account.name = Array.new(102).join("a") # 101 character, too long
    account.valid?
    account.errors.keys.include?(:name).should == true

    account.name = "Invalid name with :"
    account.valid?
    account.errors.keys.include?(:name).should == true

    account.name = "Invalid name with \""
    account.valid?
    account.errors.keys.include?(:name).should == true

    account.name = "Regular"
    account.valid?
    account.errors.keys.include?(:name).should == false
  end

  it "must have a classifiction" do
    account = Quickbooks::Model::Account.new
    account.valid?
    account.errors.keys.include?(:classification).should == true

    account.classification = 'Undocummented Classification'
    account.valid?
    account.errors.keys.include?(:classification).should == true

    account.classification = Quickbooks::Model::Account::LIABILITY
    account.valid?
    account.errors.keys.include?(:classification).should == false
  end
end

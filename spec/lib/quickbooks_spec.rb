describe Quickbooks do

  describe "VERSION" do
    subject { Quickbooks::VERSION }
    it { is_expected.to be_a String }
  end

end

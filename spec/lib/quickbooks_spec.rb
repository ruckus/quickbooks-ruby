describe Quickbooks do

  describe "VERSION" do
    subject { Quickbooks::VERSION }
    it { is_expected.to be_a String }
  end

  describe '.http_version=' do
    subject { Quickbooks.http_adapter = :net_http }

    it { expect { subject }.to change { Quickbooks.http_adapter }.from(:net_http_persistent).to(:net_http) }
  end
end

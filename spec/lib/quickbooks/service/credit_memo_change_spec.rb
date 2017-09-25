describe "Quickbooks::Service::CreditMemoChange" do
  let(:service) { construct_service :credit_memo_change }

  it "can query for credit memos" do
    xml = fixture("credit_memo_changes.xml")
    model = Quickbooks::Model::CreditMemoChange

    stub_http_request(:get, service.url_for_query, ["200", "OK"], xml)
    credit_memos = service.query
    credit_memos.entries.count.should == 1

    first_credit_memo = credit_memos.entries.first
    first_credit_memo.status.should == 'Deleted'
    first_credit_memo.id.should == "39"

    first_credit_memo.meta_data.should_not be_nil
    first_credit_memo.meta_data.last_updated_time.should == DateTime.parse("2014-12-08T19:36:24-08:00")
  end

  describe "#url_for_query" do
    subject { service.url_for_query }
    it { should eq "#{service.url_for_base}/cdc?entities=CreditMemo" }
  end

end

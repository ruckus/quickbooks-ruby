require 'spec_helper'

module Quickbooks
  module Service
    describe PaymentMethod do
      before do
        subject.company_id = "1014843225"
        subject.access_token = construct_oauth
      end

      it "queries for payment methods" do
        xml = fixture("payment_methods.xml")
        model = Model::PaymentMethod
        stub_request(:get, subject.url_for_query, ["200", "OK"], xml)

        payment_methods = subject.query.entries
        expect(payment_methods.count).to eq 8
      end

      it "queries a payment method by name" do
        xml = fixture("fetch_payment_method_by_name.xml")
        model = Model::PaymentMethod
        url = subject.url_for_query(subject.search_name_query("Discover"))
        stub_request(:get, url, ["200", "OK"], xml)

        payment_method = subject.fetch_by_name("Discover")
        expect(payment_method.name).to eq "Discover"
      end
    end
  end
end

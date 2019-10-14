require 'spec_helper'

module Quickbooks
  module Service
    describe PaymentMethod do
      before(:all) do
        @service = construct_service :payment_method
        @service.company_id = "1014843225"
        @service.access_token = construct_oauth
      end

      it "queries for payment methods" do
        xml = fixture("payment_methods.xml")
        model = Model::PaymentMethod
        stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)

        payment_methods = @service.query.entries
        expect(payment_methods.count).to eq(8)
      end

      it "queries a payment method by name" do
        xml = fixture("fetch_payment_method_by_name.xml")
        model = Model::PaymentMethod
        url = @service.url_for_query(@service.search_name_query("Discover"))
        stub_http_request(:get, url, ["200", "OK"], xml)

        payment_method = @service.fetch_by_name("Discover")
        expect(payment_method.name).to eq("Discover")
      end

      it "can fetch a payment_method by ID" do
        xml = fixture("fetch_payment_method_by_id.xml")
        model = Quickbooks::Model::PaymentMethod
        stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/7", ["200", "OK"], xml)
        payment_method = @service.fetch_by_id(7)
        payment_method.name.should eq('Discover')
      end

      it "can create a payment_method" do
        xml = fixture("fetch_payment_method_by_id.xml")
        model = Quickbooks::Model::PaymentMethod
        stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)
        payment_method = Quickbooks::Model::PaymentMethod.new
        payment_method.name = 'Discover'
        payment_method.type = Quickbooks::Model::PaymentMethod::CREDIT_CARD
        payment_method.valid_for_create?.should == true
        created_payment_method = @service.create(payment_method)
        created_payment_method.id.should == "7"
      end

      it "cannot sparse update a payment method" do
        model = Quickbooks::Model::PaymentMethod
        payment_method = Quickbooks::Model::PaymentMethod.new
        payment_method.name = "My Cool Payment Method"
        payment_method.sync_token = 0
        payment_method.id = 7
        xml = fixture("fetch_payment_method_by_id.xml")
        payment_method.valid_for_update?.should == true
        expect{ @service.update(payment_method, :sparse => true) }.to raise_error(Quickbooks::InvalidModelException, /Payment Method sparse update is not supported/)
      end

      it "can delete a payment method" do
        model = Quickbooks::Model::PaymentMethod
        payment_method = Quickbooks::Model::PaymentMethod.new
        payment_method.name = "Discover"
        payment_method.sync_token = 0
        payment_method.id = 7
        xml = fixture("deleted_payment_method.xml")
        stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)
        payment_method.valid_for_deletion?.should == true
        response = @service.delete(payment_method)
        response.name.should == "#{payment_method.name} (Deleted)"
        response.active?.should == false
      end
    end
  end
end

require 'spec_helper'

module Quickbooks
  module Service
    describe ServiceCrudJSON do

      it "has the correct content-type" do
        json_service = construct_service :tax_service
        expect(json_service.class::HTTP_CONTENT_TYPE).to eq 'application/json'
      end

      it "has the correct content-type" do
        json_service = construct_service :tax_service
        json_service.send(:parse_json, json_fixture(:tax_service_error_dup))
        expect { json_service.send(:parse_intuit_error) }.to_not raise_exception
      end
    end
  end
end

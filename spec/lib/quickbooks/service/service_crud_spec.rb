require 'spec_helper'

class ServicedClass
  extend Quickbooks::Service::ServiceCrud
end

module Quickbooks
  module Service
    describe ServiceCrud do

      it 'defaults to 1000 per batch' do
        expect(ServicedClass).to receive(:query).with(nil, page: 1, per_page: 1000).and_return(double(Quickbooks::Collection, count: 1))
        ServicedClass.query_in_batches {}
      end

      it 'enables a custom page size option' do
        expect(ServicedClass).to receive(:query).with(nil, page: 1, per_page: 10).and_return(double(Quickbooks::Collection, count: 1))
        ServicedClass.query_in_batches(nil, per_page: 10) {}
      end

      it 'finds all the batches' do
        expect(ServicedClass).to receive(:query).with(nil, page: 1, per_page: 1000).exactly(:once).and_return(double(Quickbooks::Collection, count: 1000))
        expect(ServicedClass).to receive(:query).with(nil, page: 2, per_page: 1000).exactly(:once).and_return(double(Quickbooks::Collection, count: 1))
        ServicedClass.query_in_batches {}
      end

      it 'yield the results of the query method' do
        results = double(Quickbooks::Collection, count: 1)
        expect(ServicedClass).to receive(:query).with(nil, page: 1, per_page: 1000).and_return(results)
        ServicedClass.query_in_batches { |batch| expect(batch).to eq results }
      end

      it 'does not yield results with 0 count' do
        yielded = []
        expect(ServicedClass).to receive(:query).with(nil, page: 1, per_page: 1000).exactly(:once).and_return(double(Quickbooks::Collection, count: 1000))
        expect(ServicedClass).to receive(:query).with(nil, page: 2, per_page: 1000).exactly(:once).and_return(double(Quickbooks::Collection, count: 0))
        ServicedClass.query_in_batches { |batch| yielded << batch }
        expect(yielded.size).to eq 1
      end

      it "finds by attribute" do
        results = double(Quickbooks::Collection, count: 1)
        expect(ServicedClass).to receive(:resource_for_singular).and_return ServicedClass
        expect(ServicedClass).to receive(:model).and_return ServicedClass
        expect(ServicedClass).to receive(:query).with("select * from ServicedClass where Name = 'test'", {})
        ServicedClass.find_by(:name, "test")
      end

      it "checks for existence" do
        results = double(Quickbooks::Collection, count: 1)
        expect(ServicedClass).to receive(:find_by).with(:name, "test", {}).and_return(results)
        expect(ServicedClass.exists?(:name, "test")).to be
      end

      it "finds all" do
        results = double(Quickbooks::Collection, count: 1)
        expect(results).to receive(:entries).and_return []
        expect(ServicedClass).to receive(:query).with(nil, page: 1, per_page: 1000).and_return(results)
        ServicedClass.all
      end
    end
  end
end

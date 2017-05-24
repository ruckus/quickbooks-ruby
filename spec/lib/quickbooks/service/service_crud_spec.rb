require 'spec_helper'

class ServicedClass
  extend Quickbooks::Service::ServiceCrud
end

module Quickbooks
  module Service
    describe ServiceCrud do

      it 'defaults to 1000 per batch' do
        ServicedClass.should_receive(:query).with(nil, page: 1, per_page: 1000).and_return(double(Quickbooks::Collection, count: 1))
        ServicedClass.query_in_batches {}
      end

      it 'enables a custom page size option' do
        ServicedClass.should_receive(:query).with(nil, page: 1, per_page: 10).and_return(double(Quickbooks::Collection, count: 1))
        ServicedClass.query_in_batches(nil, per_page: 10) {}
      end

      it 'finds all the batches' do
        ServicedClass.should_receive(:query).with(nil, page: 1, per_page: 1000).exactly(:once).and_return(double(Quickbooks::Collection, count: 1000))
        ServicedClass.should_receive(:query).with(nil, page: 2, per_page: 1000).exactly(:once).and_return(double(Quickbooks::Collection, count: 1))
        ServicedClass.query_in_batches {}
      end

      it 'yield the results of the query method' do
        results = double(Quickbooks::Collection, count: 1)
        ServicedClass.should_receive(:query).with(nil, page: 1, per_page: 1000).and_return(results)
        ServicedClass.query_in_batches { |batch| expect(batch).to eq results }
      end

      it 'does not yield results with 0 count' do
        yielded = []
        ServicedClass.should_receive(:query).with(nil, page: 1, per_page: 1000).exactly(:once).and_return(double(Quickbooks::Collection, count: 1000))
        ServicedClass.should_receive(:query).with(nil, page: 2, per_page: 1000).exactly(:once).and_return(double(Quickbooks::Collection, count: 0))
        ServicedClass.query_in_batches { |batch| yielded << batch }
        expect(yielded.size).to eq 1
      end

      it "finds by attribute" do
        results = double(Quickbooks::Collection, count: 1)
        ServicedClass.should_receive(:resource_for_singular).and_return ServicedClass
        ServicedClass.should_receive(:model).and_return ServicedClass
        ServicedClass.should_receive(:query).with("select * from ServicedClass where Name = 'test'", {})
        ServicedClass.find_by(:name, "test")
      end

      describe "all" do
        it "returns array of all results" do
          record1 = double("Record 1")
          record2 = double("Record 2")
          ServicedClass.should_receive(:query).with(nil, page: 1, per_page: 1).exactly(:once).and_return(double(Quickbooks::Collection, count: 1, entries: [record1]))
          ServicedClass.should_receive(:query).with(nil, page: 2, per_page: 1).exactly(:once).and_return(double(Quickbooks::Collection, count: 1, entries: [record2]))
          ServicedClass.should_receive(:query).with(nil, page: 3, per_page: 1).exactly(:once).and_return(double(Quickbooks::Collection, count: 0))
          expect(ServicedClass.all(nil, per_page: 1)).to eq([record1, record2])
        end

        it "returns array for no results" do
          results = double(Quickbooks::Collection, count: 0, entries: [])
          ServicedClass.should_receive(:query).with(nil, page: 1, per_page: 1000).and_return(results)
          expect(ServicedClass.all).to eq([])
        end
      end
    end
  end
end

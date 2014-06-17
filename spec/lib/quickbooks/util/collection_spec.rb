describe Quickbooks::Collection do
  it "is has an #each" do
    collection = Quickbooks::Collection.new()
    collection.entries = [:foo]
    expect{ |b| collection.each &b}.to yield_with_args(:foo) 
  end
  it "has a method from enumerable" do
    collection = Quickbooks::Collection.new()
    collection.entries = [:foo]
    expect( collection.first).to be(:foo)
  end
  it "doesn't error when no entries are set" do
    collection = Quickbooks::Collection.new()
    expect{collection.first}.to_not raise_error
  end
end

module Quickbooks
  class Collection
    include Enumerable
    attr_accessor :entries

    attr_accessor :body

    # Legacy Attributes (v2)
    attr_accessor :count, :current_page

    # v3 Attributes
    attr_accessor :start_position, :max_results, :total_count

    def each(*args, &block)
      (entries|| []).each *args, &block
    end
  end
end

module Quickbooks
  module Service
    class Term < BaseService
      include ServiceCrud
		
      def delete(term, options = {})
        delete_by_query_string(term)
      end

	private
        
	  def default_model_query
       "SELECT * FROM TERM"
	  end

	  def model
	    Quickbooks::Model::Term
    end

    end
  end
end

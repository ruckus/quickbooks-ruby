require 'time'

module Quickbooks
  module Model
    class MetaData < BaseModel
      xml_accessor :create_time, :from => 'CreateTime', :as => Time
      xml_accessor :last_updated_time, :from => 'LastUpdatedTime', :as => Time

      def to_xml(options = {})
        xml = %Q{<MetaData>}
        xml = "#{xml}<CreateTime>#{formatted_date(create_time)}</CreateTime>"
        xml = "#{xml}<LastUpdatedTime>#{formatted_date(last_updated_time)}</LastUpdatedTime></MetaData>"
        xml
      end

      private

      def formatted_date(datetime)
        datetime.strftime('%Y-%m-%dT%H:%M:%S%z')
      end

    end
  end
end

module Quickbooks
  module Model
    class Report < BaseModel

      attr_accessor :xml

      def all_rows
        @all_rows ||= xml.css("ColData:first-child").map {|node| parse_row(node.parent) }
      end

      def columns
        @columns ||= begin
          nodes = xml.css('Column')
          nodes.map do |node|
            # There is also a ColType field, but it does not seem valuable to capture
            node.at('ColTitle').content
          end
        end
      end

      def find_row(label)
        all_rows.find {|r| r[0] == label }
      end

      private

      # Parses the given row:
      #   <Row type="Data">
      #     <ColData value="Checking" id="35"/>
      #     <ColData value="1201.00"/>
      #     <ColData value="200.50"/>
      #   </Row>
      #
      #  To:
      #   ['Checking', BigDecimal(1201.00), BigDecimal(200.50)]
      def parse_row(row_node)
        row_node.elements.map.with_index do |el, i|
          value = el.attr('value')

          next nil if value.blank?
          next value if value.to_s.match(/^\d+$|^\d+\.\d+$|^-\d+|^-\d+\.\d+$|^\.\d+$/).nil?
          BigDecimal(value)
        end
      end

    end
  end
end

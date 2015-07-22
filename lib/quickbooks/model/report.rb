module Quickbooks
  module Model
    class Report < BaseModel

      attr_reader :xml

      def xml=(xml)
        xml.remove_namespaces!
        @xml = xml
      end

      def find_row(label)
        rows = xml.xpath("//ColData[1]")
        row = rows.find {|r| r.attr('value') == label }
        row.parent.children.map {|c| c.attr('value') }
      end

      def all_rows
        nodes = xml.xpath("//ColData[1]")
        nodes.map {|node| parse_row(node.parent) }
      end

      def columns
        @columns ||= begin
          nodes = xml.xpath('/Report/Columns/Column')
          nodes.map do |node|
            # There is also a ColType field, but it does not seem valuable to capture
            node.at('ColTitle').content
          end
        end
      end

      private
      # Parses the given row
      #
      # <Row type="Data">
      #    <ColData value="Checking" id="35"/>
      #    <ColData value="1201.00"/>
      #  </Row>
      #
      #  To:
      #  ['Checking', BigDecimal(1201.00)]
      def parse_row(row_node)
        row_node.elements.map.with_index do |el, i|
          value = el.attr('value')

          if i.zero? # Return the first column as a string, its the label.
            value
          elsif value.blank?
            nil
          else
            BigDecimal(value)
          end
        end
      end

    end
  end
end

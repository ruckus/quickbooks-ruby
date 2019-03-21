module Quickbooks
  module Model
    class PhysicalAddress < BaseModel
      xml_accessor :id, :from => 'Id'
      xml_accessor :line1, :from => 'Line1'
      xml_accessor :line2, :from => 'Line2'
      xml_accessor :line3, :from => 'Line3'
      xml_accessor :line4, :from => 'Line4'
      xml_accessor :line5, :from => 'Line5'
      xml_accessor :city, :from => 'City'
      xml_accessor :country, :from => 'Country'
      xml_accessor :country_sub_division_code, :from => 'CountrySubDivisionCode'
      xml_accessor :postal_code, :from => 'PostalCode'
      xml_accessor :note, :from => 'Note'
      xml_accessor :lat, :from => 'Lat'
      xml_accessor :lon, :from => 'Long'

      def zip
        postal_code
      end

      def lat_to_f
        BigDecimal(lat)
      end

      def lon_to_f
        BigDecimal(lon)
      end

      def have_lat?
        lat.to_s != "INVALID"
      end

      def have_lon?
        lon.to_s != "INVALID"
      end

    end
  end
end
module Quickbooks
  module Model
    class TimeActivity < BaseModel
      XML_COLLECTION_NODE = "TimeActivity"
      XML_NODE = "TimeActivity"
      REST_RESOURCE = 'timeactivity'

      NAMEOF_OPTIONS = %w( Employee Vendor )

      xml_name XML_NODE

      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData

      xml_accessor :txn_date, :from => 'TxnDate'
      xml_accessor :name_of, :from => 'NameOf'

      xml_accessor :employee_ref, :from => 'EmployeeRef', :as => BaseReference
      xml_accessor :vendor_ref, :from => 'VendorRef', :as => BaseReference
      xml_accessor :customer_ref, :from => 'CustomerRef', :as => BaseReference
      xml_accessor :item_ref, :from => 'ItemRef', :as => BaseReference
      xml_accessor :class_ref, :from => 'ClassRef', :as => BaseReference

      xml_accessor :billable_status, :from => 'BillableStatus'
      xml_accessor :taxable, :from => 'Taxable'
      xml_accessor :hourly_rate, :from => 'HourlyRate'
      xml_accessor :minutes, :from => 'Minutes', :as => Integer
      xml_accessor :hours, :from => 'Hours', :as => Integer
      xml_accessor :break_minutes, :from => 'BreakMinutes', :as => Integer
      xml_accessor :break_hours, :from => 'BreakHours', :as => Integer
      xml_accessor :description, :from => 'Description'

      xml_accessor :attachable_ref, :from => 'AttachableRef', :as => BaseReference
      xml_accessor :department_ref, :from => 'DepartmentRef', :as => BaseReference
      xml_accessor :start_time, :from => 'StartTime', :as => DateTime
      xml_accessor :end_time, :from => 'EndTime', :as => DateTime
      xml_accessor :time_zone, :from => 'TimeZone'

      reference_setters

      # == Validations
      validates_inclusion_of :name_of, :in => NAMEOF_OPTIONS
      validate :existence_of_employee_ref, :if => Proc.new { |ta| ta.name_of == "Employee" }
      validate :existence_of_vendor_ref, :if => Proc.new { |ta| ta.name_of == "Vendor" }
      validates :description, length: { maximum: 4000 }

      def existence_of_employee_ref
        if employee_ref.nil? || (employee_ref && employee_ref.value == 0)
          errors.add(:employee_ref, "EmployeeRef is required and must be a non-zero value.")
        end
      end

      def existence_of_vendor_ref
        if vendor_ref.nil? || (vendor_ref && vendor_ref.value == 0)
          errors.add(:vendor_ref, "VendorRef is required and must be a non-zero value.")
        end
      end

      def valid_for_update?
        if sync_token.nil?
          errors.add(:sync_token, "Missing required attribute SyncToken for update")
        end
        errors.empty?
      end

      def valid_for_create?
        valid?
        errors.empty?
      end

      def valid_for_deletion?
        return false if(id.nil? || sync_token.nil?)
        id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
      end

    end
  end
end

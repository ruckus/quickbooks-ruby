module NameEntity

  module Quality
    def email_address=(email_address)
      self.primary_email_address = Quickbooks::Model::EmailAddress.new(email_address)
    end

    def email_address
      primary_email_address
    end

    def names_cannot_contain_invalid_characters
      [:name, :display_name, :given_name, :middle_name, :family_name, :print_on_check_name].each do |property|
        next unless respond_to? property
        value = send(property).to_s
        if value.index(':')
          errors.add(property, ":#{property} cannot contain a colon (:).")
        end
      end
    end

    def email_address_is_valid
      if primary_email_address
        address = primary_email_address.address.to_s
        return false if address.length == 0
        unless address.index('@') && address.index('.')
          errors.add(:primary_email_address, "Email address must contain @ and . (dot)")
        end
      end
    end

    def posting_type_is_valid
      if posting_type
        unless %w(Debit Credit).include?(posting_type)
          errors.add(:posting_type, "Posting Type must be either 'Debit' or 'Credit'")
        end
      end
    end

    def billable_status_is_valid
      if billable_status
        unless %w(Billable NotBillable HasBeenBilled).include?(billable_status)
          errors.add(:posting_type, "Posting Type must be either 'Debit' or 'Credit'")
        end
      end
    end

    def entity_type_is_valid
      if entity_type
        unless %w(Customer Vendor).include?(entity_type)
          errors.add(:entity_type, "Entity Type must be either 'Customer' or 'Vendor'")
        end
      end
    end

    def journal_line_entry_tax
      if tax_code_ref
        # tax_applicable_on must be set
        errors.add(:tax_applicable_on, "TaxApplicableOn must be set when TaxCodeRef is set") if tax_applicable_on.nil?
        errors.add(:tax_amount, "TaxAmount must be set when TaxCodeRef is set") if tax_amount.nil?
      end
    end
  end

  module PermitAlterations

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

    # To delete an account Intuit requires we provide Id and SyncToken fields
    def valid_for_deletion?
      return false if(id.nil? || sync_token.nil?)
      id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
    end
  end
end

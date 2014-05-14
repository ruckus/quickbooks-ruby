module DocumentNumbering

  # Convenience method for proper AutoDocNumber tag
  # construction, which should be blank if auto
  # document numbering is desired.
  def auto_doc_number!
    self.auto_doc_number = ''
  end

  private

  def document_numbering
    if !auto_doc_number.nil? && !doc_number.nil?
      errors.add(:doc_number, "DocumentNumber should not be specified if AutoDocNumber is.")
    end
  end

end

describe "Quickbooks::Model::Term" do
  it "parses from XML" do
    xml = fixture("term.xml")
    term = Quickbooks::Model::Term.from_xml(xml)

    expect(term.id).to eq("11")
    expect(term.sync_token).to eq(0)
    expect(term.meta_data.create_time).to eq(Time.new(2013, 7, 11, 17, 46, 39, "-07:00"))
    expect(term.meta_data.last_updated_time).to eq(Time.new(2013, 7, 11, 17, 46, 42, "-07:00"))
    expect(term.name).to eq("TermForV3Testing-1373590184130")
    expect(term.active?).to be true
    expect(term.type).to eq("DATE_DRIVEN")
    expect(term.discount_percent).to eq(4.0)
    expect(term.due_days).to be_nil
    expect(term.discount_days).to be_nil
    expect(term.day_of_month_due).to eq(1)
    expect(term.due_next_month_days).to eq(2)
    expect(term.discount_day_of_month).to eq(3)
  end

  it "is invalid without a name" do
    term = Quickbooks::Model::Term.new
    expect(term).not_to be_valid
  end

  it "is valid with a name" do
    term = Quickbooks::Model::Term.new
    term.name = "Cool Term, Yo"
    expect(term).to be_valid
  end

  describe "#active?" do
    it "returns true when active == 'true'" do
      term = Quickbooks::Model::Term.new
      term.active = "true"
      expect(term).to be_truthy
    end

    it "returns false when active == 'false'" do
      term = Quickbooks::Model::Term.new
      term.active = "false"
      expect(term).not_to be_falsy
    end
  end
end

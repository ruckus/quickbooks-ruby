describe "Quickbooks::Model::Term" do
  it "parses from XML" do
    xml = fixture("term.xml")
    term = Quickbooks::Model::Term.from_xml(xml)

    term.id.should eq(11)
    term.sync_token.should eq(0)
    term.meta_data.create_time.
      should eq(Time.new(2013, 7, 11, 17, 46, 39, "-07:00"))
    term.meta_data.last_updated_time.
      should eq(Time.new(2013, 7, 11, 17, 46, 42, "-07:00"))
    term.name.should eq("TermForV3Testing-1373590184130")
    term.active?.should be_true
    term.type.should eq("DATE_DRIVEN")
    term.discount_percent.should eq(4.0)
    term.due_days.should be_nil
    term.discount_days.should be_nil
    term.day_of_month_due.should eq(1)
    term.due_next_month_days.should eq(2)
    term.discount_day_of_month.should eq(3)
  end

  it "is invalid without a name" do
    term = Quickbooks::Model::Term.new
    term.should_not be_valid
  end

  it "is valid with a name" do
    term = Quickbooks::Model::Term.new
    term.name = "Cool Term, Yo"
    term.should be_valid
  end

  describe "#active?" do
    it "returns true when active == 'true'" do
      term = Quickbooks::Model::Term.new
      term.active = "true"
      term.should be_true
    end

    it "returns false when active == 'false'" do
      term = Quickbooks::Model::Term.new
      term.active = "false"
      term.should_not be_false
    end
  end
end

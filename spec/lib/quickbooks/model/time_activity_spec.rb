describe "Quickbooks::Model::TimeActivity" do

  it "parse from XML" do
    xml = fixture("time_activity.xml")
    time_activity = Quickbooks::Model::TimeActivity.from_xml(xml)
    expect(time_activity.sync_token).to eq(0)
    expect(time_activity.txn_date).to eq("2014-02-05")
    expect(time_activity.name_of).to eq("Employee")
    expect(time_activity.employee_ref.value).to eq("66")
    expect(time_activity.employee_ref.name).to eq("John Smith")
    expect(time_activity.customer_ref.value).to eq("123")
    expect(time_activity.customer_ref.name).to eq("Test Customer")
    expect(time_activity.item_ref.value).to eq("49")
    expect(time_activity.item_ref.name).to eq("General Consulting")
    expect(time_activity.class_ref.value).to eq("100100000000000321233")
    expect(time_activity.class_ref.name).to eq("Training")
    expect(time_activity.billable_status).to eq("Billable")
    expect(time_activity.taxable).to eq("false")
    expect(time_activity.hourly_rate).to eq("115")
    expect(time_activity.hours).to eq(1)
    expect(time_activity.minutes).to eq(0)
    expect(time_activity.description).to eq("Description 1")
  end

end

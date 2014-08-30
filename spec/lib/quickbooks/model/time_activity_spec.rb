describe "Quickbooks::Model::TimeActivity" do

  it "parse from XML" do
    xml = fixture("time_activity.xml")
    time_activity = Quickbooks::Model::TimeActivity.from_xml(xml)
    time_activity.sync_token.should == 0
    time_activity.txn_date.should == "2014-02-05"
    time_activity.name_of.should == "Employee"
    time_activity.employee_ref.value.should == "66"
    time_activity.employee_ref.name.should == "John Smith"
    time_activity.customer_ref.value.should == "123"
    time_activity.customer_ref.name.should == "Test Customer"
    time_activity.item_ref.value.should == "49"
    time_activity.item_ref.name.should == "General Consulting"
    time_activity.class_ref.value.should == "100100000000000321233"
    time_activity.class_ref.name.should == "Training"
    time_activity.billable_status.should == "Billable"
    time_activity.taxable.should == "false"
    time_activity.hourly_rate.should == "115"
    time_activity.hours.should == 1
    time_activity.minutes.should == 0
    time_activity.description.should == "Description 1"
  end

end

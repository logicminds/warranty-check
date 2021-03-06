require 'spec_helper'

describe WarrantyCheck::HP do

  before(:all) do
    @sn = "CND003107K"
    
    @vendor = WarrantyCheck::HP.new(@sn)
  end

  it "gets html" do
    @vendor.html =~ Regexp.new(@sn)
  end
  
  it "parses html" do
    @vendor.dom.class.should == Nokogiri::HTML::Document
  end
  
  it "does not check bad warranty" do
    bad_vendor = WarrantyCheck::HP.new("XXXXXXXXXX")
    bad_vendor.check
    bad_vendor.warranties.size.should == 0
  end
  
  it "checks warranty" do
    @vendor.check
    @vendor.warranties.size.should == 2

    w1, w2 = @vendor.warranties
    
    w1[:description].should == "Base Warranty - Wty: HP HW Maintenance Offsite Support"
    w1[:expired].should     == true
    w1[:expire_date].should == Time.strptime("19 Feb 2011", "%d %b %Y")
    
    w1[:details][:service_type].should  == "Wty: HP HW Maintenance Offsite Support"
    w1[:details][:start_date].should    == Time.strptime("21 Jan 2010", "%d %b %Y")
    w1[:details][:end_date].should      == Time.strptime("19 Feb 2011", "%d %b %Y")
    w1[:details][:status].should        == "Expired"
    w1[:details][:service_level].should == "Std Office Hrs Std Office Days, Std Office Hrs Std Office Days, Global Coverage, Standard Material Handling, Standard Parts Logistics, Customer delivers to RepairCtr, No Usage Limitation, Customer Pickup at RepairCtr, 5 Business Days Turn-Around"
    w1[:details][:deliverables].should  == "Hardware Problem Diagnosis, Offsite Support & Materials"


    w2[:description].should == "Base Warranty - Wty: HP Support for Initial Setup"
    w2[:expired].should     == true
    w2[:expire_date].should == Time.strptime("20 May 2010", "%d %b %Y")
    
    w2[:details][:warranty_type].should == "Base Warranty"
    w2[:details][:service_type].should  == "Wty: HP Support for Initial Setup"
    w2[:details][:start_date].should    == Time.strptime("21 Jan 2010", "%d %b %Y")
    w2[:details][:end_date].should      == Time.strptime("20 May 2010", "%d %b %Y")
    w2[:details][:status].should        == "Expired"
    w2[:details][:service_level].should == "NextAvail TechResource Remote, Std Office Hrs Std Office Days, 2 Hr Remote Response, Unlimited Named Callers"
    w2[:details][:deliverables].should  == "Initial Setup Assistance"
  end

  it "checks warranty for found serial numbers" do
    custom_vendor = WarrantyCheck::HP.new("CNU8270B6C")
    custom_vendor.check
    custom_vendor.warranties.size.should == 3
  end

end
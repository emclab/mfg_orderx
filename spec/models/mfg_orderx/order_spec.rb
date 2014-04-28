require 'spec_helper'

module MfgOrderx
  describe Order do
    it "should be OK" do
      c = FactoryGirl.create(:mfg_orderx_order)
      c.should be_valid
    end
    
    it "should reject 0 quote_id" do
      c = FactoryGirl.build(:mfg_orderx_order, :quote_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 rfq_id" do
      c = FactoryGirl.build(:mfg_orderx_order, :rfq_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 qty" do
      c = FactoryGirl.build(:mfg_orderx_order, :qty => 0)
      c.should_not be_valid
    end
    
    it "should reject nil drawing#" do
      c = FactoryGirl.build(:mfg_orderx_order, :drawing_num => nil)
      c.should_not be_valid
    end
    
    it "should reject nil order_date" do
      c = FactoryGirl.build(:mfg_orderx_order, :order_date => nil)
      c.should_not be_valid
    end
  end
end

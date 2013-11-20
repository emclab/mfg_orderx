require 'spec_helper'

module MfgOrderx
  describe OrdersController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      
    end
    
    before(:each) do
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @cust = FactoryGirl.create(:kustomerx_customer) 
      @rfq = FactoryGirl.create(:jobshop_rfqx_rfq, :customer_id => @cust.id, :sales_id => @u.id)
      @rfq1 = FactoryGirl.create(:jobshop_rfqx_rfq, :product_name => 'new name', :drawing_num => '12345', :customer_id => @cust.id, :sales_id => @u.id)
      @quote = FactoryGirl.create(:jobshop_quotex_quote, :rfq_id => @rfq.id)
      @quote1 = FactoryGirl.create(:jobshop_quotex_quote, :rfq_id => @rfq1.id)
      
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns all orderss" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MfgOrderx::Order.where(:cancelled => false).order('order_date DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        o = FactoryGirl.create(:mfg_orderx_order, :rfq_id => @rfq.id, :quote_id => @quote.id)
        o1 = FactoryGirl.create(:mfg_orderx_order, :rfq_id => @rfq1.id, :quote_id => @quote1.id)
        get 'index', {:use_route => :mfg_orderx}
        assigns(:orders).should =~ [o, o1]
      end
      
      it "should return orders for the rfq" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MfgOrderx::Order.where(:cancelled => false).order('order_date DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        o = FactoryGirl.create(:mfg_orderx_order, :rfq_id => @rfq.id, :quote_id => @quote.id)
        o1 = FactoryGirl.create(:mfg_orderx_order, :rfq_id => @rfq1.id, :quote_id => @quote1.id)
        get 'index', {:use_route => :mfg_orderx, :rfq_id => @rfq1.id}
        assigns(:orders).should =~ [o1]
      end
      
      it "should return orders for the quote" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MfgOrderx::Order.where(:cancelled => false).order('order_date DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        o = FactoryGirl.create(:mfg_orderx_order, :rfq_id => @rfq.id, :quote_id => @quote.id)
        o1 = FactoryGirl.create(:mfg_orderx_order, :rfq_id => @rfq1.id, :quote_id => @quote1.id)
        get 'index', {:use_route => :mfg_orderx, :quote_id => @quote.id}
        assigns(:orders).should =~ [o]
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :mfg_orderx, :quote_id => @quote.id}
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "returns redirect with success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:mfg_orderx_order, :quote_id => @quote.id)
        get 'create', {:use_route => :mfg_orderx, :quote_id => @quote.id, :order => q}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render new with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:mfg_orderx_order, :rfq_id => nil)
        get 'create', {:use_route => :mfg_orderx, :quote_id => @quote1.id, :order => q}
        response.should render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:mfg_orderx_order, :quote_id => @quote.id)
        get 'edit', {:use_route => :mfg_orderx, :id => q.id}
        response.should be_success
      end
    end
  
    describe "GET 'update'" do
      it "should redirect successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:mfg_orderx_order, :quote_id => @quote1.id)
        get 'update', {:use_route => :mfg_orderx, :id => q.id, :order => {:order_requirement => 'steel 201'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:mfg_orderx_order, :quote_id => @quote.id)
        get 'update', {:use_route => :mfg_orderx, :id => q.id, :order => {:qty => 0}}
        response.should render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.rfq.sales_id == session[:user_id]")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:mfg_orderx_order, :quote_id => @quote.id)
        get 'show', {:use_route => :mfg_orderx, :id => q.id}
        response.should be_success
      end
    end
  
  end
end

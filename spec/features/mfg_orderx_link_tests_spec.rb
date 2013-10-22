require 'spec_helper'

describe "LinkTests" do
  mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :login => 'thistest', :password => 'password', :password_confirmation => 'password')
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "MfgOrderx::Order.where(:cancelled => false).order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "record.rfq.sales_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'mfg_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.rfq.sales_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_order', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'user_menus', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        
      @cust = FactoryGirl.create(:kustomerx_customer) 
      @rfq = FactoryGirl.create(:jobshop_rfqx_rfq, :customer_id => @cust.id, :sales_id => @u.id)
      @rfq1 = FactoryGirl.create(:jobshop_rfqx_rfq, :product_name => 'new name', :drawing_num => '12345', :customer_id => @cust.id, :sales_id => @u.id)
      @quote = FactoryGirl.create(:jobshop_quotex_quote, :rfq_id => @rfq.id)
      @quote1 = FactoryGirl.create(:jobshop_quotex_quote, :rfq_id => @rfq1.id)
      @o = FactoryGirl.create(:mfg_orderx_order, :rfq_id => @rfq.id, :quote_id => @quote.id)
           
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
    end
  
  describe "GET /mfg_orderx_link_tests" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit orders_path(:quote_id => @quote.id)
      #save_and_open_page
      page.should have_content('Orders')
      click_link 'New Order'
      #save_and_open_page
      page.should have_content('New Order')
      visit orders_path(:quote_id => @quote.id)
      click_link @o.id.to_s
      page.should have_content('Order Info')
      #save_and_open_page
      visit orders_path(:quote_id => @quote.id)      
      click_link 'Edit'
      page.should have_content('Edit Order')
      #save_and_open_page
    end
  end
end

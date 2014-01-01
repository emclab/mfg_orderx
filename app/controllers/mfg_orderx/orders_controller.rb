require_dependency "mfg_orderx/application_controller"

module MfgOrderx
    
  class OrdersController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record
    
    def index
      @title = t('Orders')
      @orders = params[:mfg_orderx_orders][:model_ar_r]
      @orders = @orders.where(:rfq_id => @rfq.id) if @rfq
      @orders = @orders.where(:quote_id => @quote.id) if @quote
      @orders = @orders.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('order_index_view', 'mfg_orderx_orders')
    end
  
    def new
      @title = t('New Order')
      @order = MfgOrderx::Order.new()
      @erb_code = find_config_const('order_new_view', 'mfg_orderx_orders')
    end
  
    def create
      @order = MfgOrderx::Order.new(params[:order], :as => :role_new)
      @order.last_updated_by_id = session[:user_id]
      if @order.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @rfq = MfgOrderx.rfq_class.find_by_id(params[:order][:rfq_id]) if params[:order].present? && params[:order][:rfq_id].present?
        @quote = MfgOrderx.quote_class.find_by_id(params[:order][:quote_id]) if params[:order].present? && params[:order][:quote_id].present?
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Order')
      @order = MfgOrderx::Order.find_by_id(params[:id])
      @erb_code = find_config_const('order_edit_view', 'mfg_orderx_orders')
    end
  
    def update
      @order = MfgOrderx::Order.find_by_id(params[:id])
      @order.last_updated_by_id = session[:user_id]
      if @order.update_attributes(params[:order], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Order Info')
      @order = MfgOrderx::Order.find_by_id(params[:id])
      @erb_code = find_config_const('order_show_view', 'mfg_orderx_orders')
    end
    
    protected
    def load_parent_record
      @rfq = MfgOrderx.rfq_class.find_by_id(params[:rfq_id]) if params[:rfq_id].present?
      @rfq = MfgOrderx.rfq_class.find_by_id(MfgOrderx.quote_class.find_by_id(params[:quote_id]).rfq_id) if params[:quote_id].present?
      @quote = MfgOrderx.quote_class.find_by_id(params[:quote_id]) if params[:quote_id].present?
      @rfq = MfgOrderx.rfq_class.find_by_id(MfgOrderx::Order.find_by_id(params[:id]).rfq_id) if params[:id].present?
      @quote = MfgOrderx.quote_class.find_by_id(MfgOrderx::Order.find_by_id(params[:id]).quote_id) if params[:id].present?
    end
  end
end

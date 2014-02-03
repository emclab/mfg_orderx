module MfgOrderx
  class Order < ActiveRecord::Base
    attr_accessor :product_info, :customer_name, :expedite_noupdate, :cancelled_noupdate, :completed_noupdate, :sample_required_noupdate, :quote_id_noupdate, 
                  :quote_unit_price, :order_total, :order_wt, :unit_price, :product_wt, :id_noupdate, :wf_comment
    attr_accessible :cancelled, :completed, :customer_po, :delivery_date, :expedite, :last_updated_by_id, :order_date, :order_requirement, :qty, 
                    :quote_id, :sample_required, :shipping_date, :contract_required, :executioner_id, :rfq_id, :wfid, :wf_state,
                    :product_info, :customer_name, :quote_id_noupdate, :quote_unit_price, :order_total, :order_wt, :unit_price, :product_wt,
                    :as => :role_new
    attr_accessible :cancelled, :completed, :customer_po, :delivery_date, :expedite, :last_updated_by_id, :order_date, :order_requirement, :qty, 
                    :sample_required, :shipping_date, :contract_required, :executioner_id, :wfid, :wf_state,
                    :product_info, :customer_name, :expedite_noupdate, :cancelled_noupdate, :completed_noupdate, :sample_required_noupdate, :quote_id_noupdate, 
                    :quote_unit_price, :order_total, :order_wt, :unit_price, :product_wt, :id_noupdate, :wf_comment,
                    :as => :role_update
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :executioner, :class_name => 'Authentify::User' 
    belongs_to :rfq, :class_name => MfgOrderx.rfq_class.to_s
    belongs_to :quote, :class_name => MfgOrderx.quote_class.to_s
    
    validates :quote_id, :rfq_id, :presence => true,
                         :numericality => {:greater_than => 0}
    validates :qty, :presence => true,
                    :numericality => {:greater_than => 0, :message => I18n.t('Qty > 0')}                     
    validates_presence_of :customer_po, :order_date
  end
end

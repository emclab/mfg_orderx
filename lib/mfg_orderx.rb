require "mfg_orderx/engine"

module MfgOrderx
  mattr_accessor :quote_class, :rfq_class, :customer_class, :rfq_engine, :sample_engine, :show_rfq_path
  
  def self.quote_class
    @@quote_class.constantize
  end
  
  def self.rfq_class
    @@rfq_class.constantize
  end
  
  def self.customer_class
    @@customer_class.constantize
  end
  
end

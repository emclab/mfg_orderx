JobshopRfqx.customer_class = 'Kustomerx::Customer'
JobshopRfqx.quote_index_path = 'jobshop_quotex.quotes_path(:rfq_id => r.id, :parent_record_id => r.id, :parent_resource => params[:controller])'
JobshopRfqx.order_index_path = "mfg_orderx.orders_path(:rfq_id => r.id, :parent_record_id => r.id, :parent_resource => params[:controller])"
JobshopRfqx.mfg_process_index_path = "mfg_processx.mfg_processes_path(:rfq_id => r.id, :parent_record_id => r.id, :parent_resource => params[:controller] )"

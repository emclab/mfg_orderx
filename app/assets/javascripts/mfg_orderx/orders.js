// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
   $("#order_order_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#order_delivery_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#order_shipping_date").datepicker({dateFormat: 'yy-mm-dd'});
});

$(function (){
	$('#order_qty').change(function(){
		$('#order_order_total').val(OrderTotal());
		$('#order_order_wt').val(OrderWT());
	});
});

function OrderTotal() {
	var unit_price = parseFloat($('#order_unit_price').val());
	var qty = parseFloat($('#order_qty').val());
	if ($.isNumeric(unit_price) && $.isNumeric(qty)) {
		return (unit_price * qty).toFixed(2);
	};
	return;
};

function OrderWT() {
	var product_wt = parseFloat($('#order_product_wt').val());
	var qty = parseFloat($('#order_qty').val());
	if ($.isNumeric(product_wt) && $.isNumeric(qty)) {
		return ((product_wt * qty)/1000.00).toFixed(2);
	};
	return;
};
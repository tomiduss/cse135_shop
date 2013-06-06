//=require jquery

var $products = $products || {};

$products.update_p = function(sku){
	//var params = { 0: name, 1: list_price, 2: category_id };
	console.log(sku);	
	var name = $("#name_"+sku+" input").val();
	var price = $("#price_"+sku+" input").val();
	var cat = $("#cat_"+sku+" .cat_select option:selected").val();
	console.log(cat);
	var params = { 0: name, 1: price, 2: cat};
	makeRequest(params, "update", sku);
};

$products.insert_p = function(){
	//Check errors in input.
	
	var sku = $("#form_sku").val();
	console.log(sku);
	var name = $("#form_name").val();
	var price = $("#form_price").val();
	var cat = $("#form_category option:selected").val();
	var params = { 0: name, 1: price, 2: cat};
	console.log(params);
	makeRequest(params, "insert", sku);
	
};

$products.delete_p = function(sku){
	$("#row_"+sku).remove();
	var params = {};
		//make ajax request
	//set params
	makeRequest(params,"delete", sku);	
};

function makeRequest(params, actionType, sku){
	$.ajax({
		type: "POST",
		url: "product_ajaxresponse.jsp",
		data:{
			action: actionType,
			sku: sku,
			name: params[0],
			list_price: params[1],
			categoryid: params[2]
		},
		beforeSend:function(){
			//Update Stats
			$('#status').empty();
			$('#status').html('Request Sent');
		},
		success:function(result){
			switch(actionType){
			case "insert":
				$("#insert_row").after('<tr id="row_'+sku+'" ></tr>');//append row
				$("#row_"+sku).append('<td id="sku_'+sku+'">'+sku+'</td>');//product id
				$("#row_"+sku).append('<td id="name_'+sku+'"><input value="'+params[0]+'" name="name" size="15" /></td>');//product name
				$("#row_"+sku).append('<td id="price_'+sku+'"><input value="'+params[1]+'" name="list_price" size="5" /></td>');//product list price
				$("#row_"+sku).append('<td id="cat_'+sku+'"></td>');
				var select = $("#form_category").clone();
//				$("#cat_"+sku).append('<select name="categoryid"><% while (category_rs.next()) {if(category_rs.getInt("id") == cat_id) {%> <option value="<%= category_rs.getInt("id") %>" selected="selected"><%= category_rs.getString("category_name") %></option><% } else { %><option value="<%= category_rs.getInt("id") %>"><%= category_rs.getString("category_name") %></option><% } } %></select>');
				$("#cat_"+sku).append(select);
				select.val(params[2]);
				$("#row_"+sku).append('<td><input onClick="$products.update_p('+sku+','+params[0]+','+params[1]+','+params[2]+')" type="button" value="Update" /></td>');
				$("#row_"+sku).append('<td><input onClick="$products.delete_p('+sku+')" type="button" value="Delete" /></td>');
				$('#status').empty();
				$('#status').append('Product with sku: '+sku+' inserted succesfully');
				break;
			
			case "delete":
				$("#row_"+sku).remove();
				$('#status').empty();
				$('#status').html('Product with sku: '+sku+' deleted succesfully');
				break;
				
			case "update":
				$('#status').empty();
				$('#status').html('Product with sku: '+sku+' updated succesfully');
				break;
		
			}
			$("#form_sku").val("");
			$("#form_name").val("");
			$("#form_price").val("");
			$("#form_category").val('1');
		},
		error:function(){
			console.log(params);
			$('#status').empty();
			$('#status').html('Oops! Error.');
		}
	});	
};

function enableUpdate(){
	$(".update_button").attr('disabled','disabled');
	$(".name_input").change(function(){
		console.log("algo cambio");
		if($(this).val != ''){
            if( $(".update_button").attr('disabled') === 'disabled' )
            	$(".update_button").removeAttr('disabled');
         }
	});
	$(".price_input").change(function(){
		console.log("algo cambio");
		if($(this).val != ''){
            if( $(".update_button").attr('disabled') === 'disabled' )
            	$(".update_button").removeAttr('disabled');
         }
	});
	$(".cat_select").change(function(){
		console.log("algo cambio");
		if( $(".update_button").attr('disabled') === 'disabled' ){
			
			$(".update_button").removeAttr('disabled');
		}
	});
};
//
$(document).ready(enableUpdate);
//$(document).ready($products.update_p);
//$(document).ready($products.delete_p);


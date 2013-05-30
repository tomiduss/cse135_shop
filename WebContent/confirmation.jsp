<html>
<%-- Import the java.sql package --%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Calendar"%>
<jsp:include page="/menu.jsp" />
<%-- -------- Open Connection Code -------- --%>
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	try {
	    // Registering Postgresql JDBC driver with the DriverManager
	    Class.forName("org.postgresql.Driver");

	    // Open a connection to the database using DriverManager
	    conn = DriverManager.getConnection(
	        "jdbc:postgresql://localhost/postgres?" +
	        "user=postgres&password=leviathan");
		String action = request.getParameter("action");
		
		//CONFIRMATION
		if(action != null && action.equals("confirm")){
			
			//Select the items of the cart
			PreparedStatement statement = conn.prepareStatement("SELECT product.*, cart.quantity as quantity FROM cart JOIN product ON (cart.productsku = product.sku) WHERE cart.userid = ?");
			Integer user_id = (Integer) session.getAttribute("id");
			Boolean session_error = false;
			if (user_id != null && user_id != 0){
				statement.setInt(1, user_id);
				rs = statement.executeQuery();
			}else{
				session_error = true;
			}

			//Get user info
	       	PreparedStatement uistmt = conn.prepareStatement("select * from shop_user where id = ? LIMIT 1");
	       	uistmt.setInt(1, user_id);
	        ResultSet user_info = uistmt.executeQuery();
	        			
			//Foreach row in cart, insert into purchase table and spring/summer/fall/winter_sales tables
			while(rs.next()) {

				conn.setAutoCommit(false);
				// Create the prepared statement and use it to
		        // Inser products INTO the Purchase table.
		        // Get timestamp
				//Variables:
		        
				
		        int sku = (Integer) rs.getInt("sku");
		        
				
				pstmt = conn.prepareStatement("INSERT INTO purchase (userid, productsku, purchase_date, quantity, total_cost) VALUES (?,?,?,?,?)");
				pstmt.setInt(1, user_id);
				pstmt.setInt(2, sku);
				
				// Prepare and set timestamp
				java.util.Date date = new java.util.Date(System.currentTimeMillis());
				java.sql.Timestamp timestamp = new java.sql.Timestamp(date.getTime());
				pstmt.setTimestamp(3, timestamp);
				//quantity
				int q = rs.getInt("quantity");
				int total_cost = q*rs.getInt("list_price");
				pstmt.setInt(4, q);
				pstmt.setInt(5, total_cost);
				
				
				int rowCount = pstmt.executeUpdate();
				
				// Commit transaction
				conn.commit();
		        conn.setAutoCommit(true);
		        
		        
		        //INSERT INTO PRECOMPUTED TABLES.
		        conn.setAutoCommit(false);
				// Create the prepared statement and use it to
		        // Inser products INTO the _SALES table.
		        
		        // Get timestamp
				//Determine which quarter is the purchase be inserted.
		        Calendar cal = Calendar.getInstance();
				cal.setTime(date);
		        int month = cal.get(Calendar.MONTH);
		        String quarter;
		       	if (month >= 3 && month <= 5)
		       		quarter = "spring";
		       	else if( month >= 6 && month <= 8 )
		       		quarter = "summer";
		       	else if( month >= 9 && month <= 11 )
		       		quarter = "fall";
		       	else
		       		quarter = "winter";
		       	
		       	//Get product info
		        PreparedStatement prodstmt = conn.prepareStatement("select * from product where sku = ?");
		       	prodstmt.setInt(1, sku);
		        
		       	ResultSet prod_info = prodstmt.executeQuery();
		       	if(prod_info.next() && user_info.next() ){
		       	//Prepare stmt for insert in sales tables.
			        PreparedStatement update_st = conn.prepareStatement("INSERT INTO "+quarter+"_sales (sku, name, categoryid, id, username, state, age, total_cost) VALUES (?,?,?,?,?,?,?,?)");
			       	//product sku
			       	update_st.setInt(1, sku);
			       	//product name
			       	
			       	//
			       	
	 		    	update_st.setString(2, prod_info.getString("name"));
			       	//category ID
			       	update_st.setInt(3, (Integer) prod_info.getInt("categoryid"));
			       	//user ID
			       	update_st.setInt(4, user_id);		       	
			       	//user username
			       	update_st.setString(5, user_info.getString("username"));
			       	//user's state
			       	update_st.setString(6, user_info.getString("state"));		       	
			       	//user age
			       	update_st.setInt(7, (Integer) user_info.getInt("age"));
			       	//total_cost
					update_st.setInt(8, total_cost);
					
					
	 				rowCount = update_st.executeUpdate();
					
	 				user_info.close();
	 				prod_info.close();
	 				// Commit transaction
	 				conn.commit();
	 		        conn.setAutoCommit(true);	
		       	}       	
		        
		        
		        
		        
		        
			}
	        
			// Show confirmation of products purchased
			
	        // Create the statement
	        PreparedStatement statement2 = conn.prepareStatement("SELECT product.*, cart.quantity as quantity FROM cart JOIN product ON (cart.productsku = product.sku) WHERE cart.userid = ?", ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
	      	statement2.setInt(1, (Integer) session.getAttribute("id"));
	      	rs = statement2.executeQuery();

	      		if(rs.next()){
	      			%>
	      			<h1>Your purchase is complete!</h1>
	      			<table cellpadding="5">
	      				<tr>
	      					<th>SKU</th>
	      					<th>Name</th>
	      					<th>List price</th>
	      					<th>Category</th>
	      					<th>Quantity</th>
	      				</tr>
	      			<%
	      			do{// Iterate over the ResultSet
	      				%>
	      				<tr>
	      						<%-- Get the sku --%>
	      						<td><%=rs.getInt("sku")%></td>

	      						<%-- Get the product name --%>
	      						<td><%=rs.getString("name")%></td>

	      						<%-- Get the price --%>
	      						<td><%=rs.getInt("list_price")%></td>

	      						<%-- Get the category --%>
	      						<td><%=rs.getInt("categoryid")%></td>
	      						
	      						<%-- Get the quantity --%>
	      						<td><%=rs.getInt("quantity")%></td>
	      						
	      				</tr>
	      						
	      				<%
	      			}while (rs.next());
	      			%>
	      			<tr>
	      				<td colspan="2">
	      				<b>Total</b>
	      				<% 	
	      				rs.beforeFirst();
	      				int sum = 0;
	      				while(rs.next()) {
	      					sum += rs.getInt("list_price")*rs.getInt("quantity");
	      				}
	      				%>
	      				</td>
	      				<td>
	      				<%= sum %>
	      				</td>
	      			</tr>
	      			</table>
	      			

	      		<% }
	      		
	      		//Delete all products from cart
				conn.setAutoCommit(false);
				
			    PreparedStatement delete_cart_stmt = conn.prepareStatement("DELETE FROM cart WHERE cart.userid = ?");
		        delete_cart_stmt.setInt(1, (Integer) session.getAttribute("id"));
				int delete_rowCount = delete_cart_stmt.executeUpdate();
				
				conn.commit();
		        conn.setAutoCommit(true);
		        
		}else{
		
		
		//CREDIT CARD FORM %>
		<form action="confirmation.jsp" method="POST">
			<input type="hidden" name="action" value="confirm">
			<label>CreditCard Number </label>
			<input type="text" name="creditcard"/>
			<input type="submit" value="Confirm Purchase">
		</form>
		
		<%
		}

		//Close connection code 
    	// Close the ResultSet
    	if(rs != null) rs.close();

    	// Close the Connection
    	conn.close();
	} catch (SQLException e) {
    	// Wrap the SQL exception in a runtime exception to propagate
    	// it upwards
    	throw new RuntimeException(e);
	}
	finally {
    	// Release resources in a finally block in reverse-order of
    	// their creation

    	if (rs != null) {
        	try {
            	rs.close();
        	} catch (SQLException e) { } // Ignore
        	rs = null;
    	}
    	if (pstmt != null) {
        	try {
            	pstmt.close();
        	} catch (SQLException e) { } // Ignore
        	pstmt = null;
    	}
    	if (conn != null) {
        	try {
            	conn.close();
        	} catch (SQLException e) { } // Ignore
        	conn = null;
    }
}
%>
</html>

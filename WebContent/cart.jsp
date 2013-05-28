<html>
<%-- Import the java.sql package --%>
<%@ page import="java.sql.*"%>
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
		
%>

<%-- -------- Update Code -------- --%>
<%
      // Check if a delete is requested
      if (action != null && action.equals("update")) {

          // Begin transaction
          conn.setAutoCommit(false);

          // Create the prepared statement and use it to
          int q = Integer.parseInt(request.getParameter("q"));
          
          if( q == 0 ){// DELETE products FROM the CART table.
              pstmt = conn.prepareStatement("DELETE FROM cart WHERE productsku = ? AND userid = ?");
            pstmt.setInt(1, Integer.parseInt(request.getParameter("sku")));  
          	pstmt.setInt(2, (Integer) session.getAttribute("id"));
          }
          else{//UPDATE products FROM cart table
        	  pstmt = conn.prepareStatement("UPDATE cart SET quantity= ?  WHERE productsku = ? AND userid = ?");
        	  pstmt.setInt(1, q);
          	  pstmt.setInt(2, Integer.parseInt(request.getParameter("sku")));
          	  pstmt.setInt(3, (Integer) session.getAttribute("id"));
          }
          
          int rowCount = pstmt.executeUpdate();

          // Commit transaction
          conn.commit();
          conn.setAutoCommit(true);
      }
//------- INSERT CODE ----------
	
	if(action != null && action.equals("insert")){
		conn.setAutoCommit(false);

        // Create the prepared statement and use it to
        // Inser products INTO the CART table.
        pstmt = conn.prepareStatement("INSERT INTO cart (userid, productsku, quantity) VALUES (?,?,?)");
		
        pstmt.setInt(1, (Integer) session.getAttribute("id"));
		pstmt.setInt(2, Integer.parseInt(request.getParameter("sku")));
		int quantity = Integer.parseInt(request.getParameter("quantity"));
		pstmt.setInt(3, quantity);
		int price = Integer.parseInt(request.getParameter("price"));
		int rowCount = pstmt.executeUpdate();

          // Commit transaction
        conn.commit();
        conn.setAutoCommit(true);
	}



  %>

<%-- -------- SELECT Statement Code -------- --%>
<%
  // Create the statement
  PreparedStatement statement = conn.prepareStatement("SELECT product.* ,cart.quantity as quantity FROM cart JOIN product ON (cart.productsku = product.sku) WHERE cart.userid = ?", ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
  Boolean session_error = false;
  if (session.getAttribute("id") != null){
	  	statement.setInt(1, (Integer) session.getAttribute("id"));
	rs = statement.executeQuery();
  }else{
	session_error = true;
  }
	
	if (session_error){
		%><p>You must log in to see your cart</p>
<%
	}
	else {
		%>
<body>
	<h1>Shopping Cart</h1>
	<%
		if(rs.next()){
			%>

	<table>
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
			<form action="cart.jsp" method="POST">
				<input type="hidden" name="action" value="update" /> <input
					type="hidden" value="<%=rs.getInt("sku")%>" name="sku" />
				<%-- Update quantity --%>
				<td><input name="q" type="number" min=0 step=1 value="<%=rs.getInt("quantity")%>" /></td>
				<%-- Button --%>
				<td><input type="submit" value="Update" /></td>

			</form>

		</tr>

		<%
			}while (rs.next());
			%>
		<tr>
			<td colspan="3"><b>Total</b> <% 	
				rs.beforeFirst();
				int sum = 0;
				while(rs.next()) {
					sum += rs.getInt("list_price")*rs.getInt("quantity");
				}
				%></td>
			<td><%= sum %></td>
		</tr>
	</table>
	<form action="confirmation.jsp" method="POST">
		<input type="hidden" name="action" value="buy" /> Proceed to check
		out: <input type="submit" value="Buy Items" />
	</form>
	<%
			//Proceed to purchase.
			
			
		}else{//Display empty cart message
			%><p>Your cart is empty</p>
	<%
		}
		%>

</body>

<%
	}
	//Close connection code 
    // Close the ResultSet
    if(rs != null) rs.close();

    // Close the Statement
    statement.close();

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

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<% 
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet product_rs = null;
ResultSet category_rs = null;

try{
    Class.forName("org.postgresql.Driver");

    // Open a connection to the database using DriverManager
    conn = DriverManager.getConnection(
        "jdbc:postgresql://localhost/postgres?" +
        "user=postgres&password=leviathan");
    
    String action = request.getParameter("action");
    
	//------DELETE CODE--------//
    if (action != null && action.equals("delete")){
       // Begin transaction
       conn.setAutoCommit(false);

       // Create the prepared statement and use it to
       // DELETE students FROM the Students table.
       pstmt = conn.prepareStatement("DELETE FROM product WHERE sku = ?");

       pstmt.setInt(1, Integer.parseInt(request.getParameter("sku")));
       int rowCount = pstmt.executeUpdate();

       // Commit transaction
       conn.commit();
       conn.setAutoCommit(true);
	}
	
	//------INSERT CODE-----//
	if (action != null && action.equals("insert")) {

         // Begin transaction
         conn.setAutoCommit(false);

         // Create the prepared statement and use it to
         // INSERT student values INTO the students table.
         pstmt = conn.prepareStatement("INSERT INTO product (sku, name, list_price, categoryid) VALUES (?, ?, ?, ?)");

         pstmt.setInt(1, Integer.parseInt(request.getParameter("sku")));
         pstmt.setString(2, request.getParameter("name"));
         pstmt.setInt(3, Integer.parseInt(request.getParameter("list_price")));
         pstmt.setInt(4, Integer.parseInt(request.getParameter("categoryid")));
         int rowCount = pstmt.executeUpdate();

         // Commit transaction
         conn.commit();
         conn.setAutoCommit(true);
     }
	//-----Update Code------//
     if (action != null && action.equals("update")) {

        // Begin transaction
        conn.setAutoCommit(false);

        // Create the prepared statement and use it to
        // UPDATE student values in the Students table.
        pstmt = conn.prepareStatement("UPDATE product SET name = ?, list_price = ?, categoryid = ? WHERE sku = ?");

        pstmt.setString(1, request.getParameter("name"));
        pstmt.setInt(2, Integer.parseInt(request.getParameter("list_price")));
        pstmt.setInt(3, Integer.parseInt(request.getParameter("categoryid")));
        pstmt.setInt(4, Integer.parseInt(request.getParameter("sku")));
        int rowCount = pstmt.executeUpdate();

        // Commit transaction
        conn.commit();
        conn.setAutoCommit(true);
    }
    
	
}
catch (SQLException e) {

    // Wrap the SQL exception in a runtime exception to propagate
    // it upwards
    throw new RuntimeException(e);
}
finally {
    // Release resources in a finally block in reveproduct_rse-order of
    // their creation

    if (product_rs != null) {
        try {
            product_rs.close();
        } catch (SQLException e) { } // Ignore
        product_rs = null;
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
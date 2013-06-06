<%@page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
			            
<% 
	// Open connection to database
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

    // Delete old entries
	java.util.Date date = new java.util.Date(System.currentTimeMillis());
	java.sql.Timestamp timestamp = new java.sql.Timestamp(date.getTime());
	String today = timestamp.toString().substring(0,10);
    try {
    	conn.createStatement().executeQuery("DELETE FROM log WHERE date < '"+today+"'");
    } catch (SQLException e) { } //Do nothing
    
    // Get log from database
    rs = conn.createStatement().executeQuery("SELECT * FROM log");

	// Create JSON
    JSONArray json = new JSONArray();
    JSONObject obj=new JSONObject();

    while (rs.next()) {
    	obj=new JSONObject();
    	obj.put("id", rs.getInt("id"));
    	obj.put("state", rs.getString("state"));
    	obj.put("categoryid", rs.getInt("categoryid"));
    	obj.put("amount", rs.getInt("amount"));
    	json.add(obj);
    }
    
    out.print(json);
	out.flush();

    // Close the ResultSet
    rs.close();

    // Close the Connection
    conn.close();
	} catch (SQLException e) {

    // Wrap the SQL exception in a runtime exception to propagate
    // it upwards
    throw new RuntimeException(e);
	} finally {
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



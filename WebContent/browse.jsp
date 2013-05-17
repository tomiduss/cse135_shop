<html>

<body>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="/menu.jsp" />
        </td>
    </tr>
    <tr>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet product_rs = null;
            ResultSet category_rs = null;
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=leviathan");
            %>
            
            <%-- -------- INSERT Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("insert")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // INSERT student values INTO the students table.
                    pstmt = conn
                    .prepareStatement("INSERT INTO product (sku, name, list_price, categoryid) VALUES (?, ?, ?, ?)");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("sku")));
                    pstmt.setString(2, request.getParameter("name"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("list_price")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("categoryid")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
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
            %>
            
            <%-- -------- DELETE Code -------- --%>
            <%
                // Check if a delete is requested
                if (action != null && action.equals("delete")) {

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
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();
				
            	String query = request.getParameter("query");
            	if(query != null) {
            		product_rs = statement.executeQuery("SELECT * FROM product" + query);
            	}
            	else {
            		product_rs = statement.executeQuery("SELECT * FROM product");
            	}
            	
            	String search = request.getParameter("search");
            	if(search != null) {
            		product_rs = statement.executeQuery("SELECT * FROM product WHERE name LIKE '" + search + "%'");
            	}
                
            %>
            
            <%-- Retrieve Category names and IDs --%>
            
            <%
         		// Create the statement
            	Statement statement2 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);

            	// Use the created statement to SELECT
            	// the student attributes FROM the Student table.
            	category_rs = statement2.executeQuery("SELECT id, category_name FROM category");
            	
            
            %>
            <!-- Add an HTML table header row to format the results -->
            <table>
            <tr><td height="50" valign="top"><form action="browse.jsp" method="POST"><input name="search" value="" size="50"/>    
            <input type="submit" value="Search"/></form></td>
            </tr>
            <tr><td valign="top">
            <table>
            <tr>
            <td width=200>
            <form action="browse.jsp" method="POST"><input type="hidden" name="query" value=""/>
			All products
            </td>
            <td>
            <input type="submit" value="Show"/></form>
            </td>
            </tr>
            <% while(category_rs.next()) { %>
            <tr>
            <td width=200>
            <form action="browse.jsp" method="POST"><input type="hidden" name="query" value=" WHERE categoryid=<%= category_rs.getInt("id")%>"/>
			<%= category_rs.getString("category_name") %>
            </td>
            <td>
            <input type="submit" value="Show"/></form>
            </td>
            </tr>
            <% } %>
       		</table></td>
       		<td width=100>
       		</td>
            <td valign="top">
            <table cellpadding="5">
            <tr>
                <th>SKU</th>
                <th>Name</th>
                <th>List price</th>
                <th>Category</th>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                
                while (product_rs.next()) {
                category_rs.beforeFirst();
            %>

            <tr>
                <td>
                    <%=product_rs.getInt("sku")%>
                </td>
                <td>
                   	<%=product_rs.getString("name")%>
                </td>
                <td>
                    <%=product_rs.getInt("list_price")%>
                </td>
                <td>
                    <% while (category_rs.next()) { 
                    	if(category_rs.getInt("id") == product_rs.getInt("categoryid")) {
                    	%>
                    <%= category_rs.getString("category_name") %> <% } } %>
                </td>

                <%-- Button --%>           
                <form action="cart.jsp" method="POST">
                    <input type="hidden" value="<%=product_rs.getInt("sku")%>" name="insert"/>
                    <%-- Button --%>
                    <td><input type="submit" value="Buy"/></td>
                </form>
            </tr>
            <%
                }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                product_rs.close();

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
        </table>
        </td>
        </tr>
        </table>
        </td>
    </tr>
</table>
</body>

</html>


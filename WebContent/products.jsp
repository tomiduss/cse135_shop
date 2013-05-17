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
            <tr><td>Search:</td></tr>
            
            <tr><td>
            <table>
            <tr>
            <td width=200>
            <form action="products.jsp" method="POST"><input type="hidden" name="query" value=""/>
			All products
            </td>
            <td>
            <input type="submit" value="Show"/></form>
            </td>
            </tr>
            <% while(category_rs.next()) { %>
            <tr>
            <td width=200>
            <form action="products.jsp" method="POST"><input type="hidden" name="query" value=" WHERE categoryid=<%= category_rs.getInt("id")%>"/>
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
            <td>
            <table>
            <tr>
                <td>SKU</td>
                <td>Name</td>
                <td>List price</td>
                <td>Category</td>
            </tr>

            <tr>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <td><input value="" name="sku" size="5"/></td>
                    <td><input value="" name="name" size="15"/></td>
                    <td><input value="" name="list_price" size="5"/></td>
                    <td>
                    <select name="categoryid">
                    <% while (category_rs.next()) { %>
                    <option value="<%= category_rs.getInt("id") %>"><%= category_rs.getString("category_name") %></option>
                    <% } %>
                    </select>
                    </td>
                    <td><input type="submit" value="Insert"/></td>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (product_rs.next()) {
                	category_rs.beforeFirst();
            %>

            <tr>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="sku" value="<%=product_rs.getInt("sku")%>"/>

                <%-- Get the id --%>
                <td>
                    <%=product_rs.getInt("sku")%>
                </td>

                <%-- Get the fiproduct_rst name --%>
                <td>
                    <input value="<%=product_rs.getString("name")%>" name="name" size="15"/>
                </td>

                 <%-- Get the id --%>
                <td>
                    <input value="<%=product_rs.getInt("list_price")%>" name="list_price" size="5"/>
                </td>
                
                 <%-- Get the id --%>
                <td>
                	<select name="categoryid">
                    <% while (category_rs.next()) { 
                    	if(category_rs.getInt("id") == product_rs.getInt("categoryid")) {
                    	%>
                    <option value="<%= category_rs.getInt("id") %>" selected="selected"><%= category_rs.getString("category_name") %></option>
                    	<% } else { %>
                    <option value="<%= category_rs.getInt("id") %>"><%= category_rs.getString("category_name") %></option>
                    <% } } %>
                    </select>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=product_rs.getInt("sku")%>" name="sku"/>
                    <%-- Button --%>
                <td><input type="submit" value="Delete"/></td>
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


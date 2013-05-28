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
            Statement statement = null;
            int category_id = 0;
            String search = "";
            if(request.getParameter("category_id") != null) category_id = Integer.parseInt(request.getParameter("category_id"));
            if(request.getParameter("search") != null) search = request.getParameter("search");

            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=leviathan");
            %>
            
<%-- -------- SELECT Statement Code -------- --%>
<!-- -----------------Using GET ----------------------  --> 
            <%
            	String query = "SELECT * FROM product";
            	if (category_id != 0) query += " WHERE categoryid = " + category_id;
            	if (search != "") query += " AND name LIKE '" + search + "%'";
            	product_rs = conn.createStatement().executeQuery(query);
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
					<tr>
						<td height="50" valign="top">			 
							<form action="browse.jsp" method="GET">
								<input name="category_id" type="hidden" value=<%=category_id%> />
								<input name="search" type="text" value="" size="50" />
								<input type="submit" value="Search" />
							</form>
						</td>
					</tr>
					<tr>
						<td valign="top">
							<table>
								<tr>
									<td width=200>
										<a href="browse.jsp?" method="GET">All products</a>
									</td>
									</form></td>
								</tr>
								<% while(category_rs.next()) { %>
								<tr>
									<td>
										<a href="browse.jsp?category_id=<%=category_rs.getInt("id")%>" method="GET"><%= category_rs.getString("category_name") %> </a>
									</td>
								</tr>								
								
								<% } %>
							</table>
						</td>
						<td width=100></td>
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
									<td><%=product_rs.getInt("sku")%></td>
									<td><%=product_rs.getString("name")%></td>
									<td><%=product_rs.getInt("list_price")%></td>
									<td>
										<% while (category_rs.next()) { 
                    	if(category_rs.getInt("id") == product_rs.getInt("categoryid")) {
                    	%> <%= category_rs.getString("category_name") %> <% } } %>
									</td>

									<%-- Button --%>
									<form action="cart.jsp" method="POST">
										<input type="hidden" value="<%=product_rs.getInt("sku")%>"
											name="sku" />
										<input type="hidden" name="action" value="insert"/>
										<%-- Button --%>
										<td><input type="submit" value="Buy" /></td>
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
                if(statement != null) {
                    statement.close();
                }

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


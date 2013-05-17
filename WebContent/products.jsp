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
				ResultSet rs = null;
				
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

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery("SELECT * FROM product");
            %>
            
            <%-- Retrieve Category names and IDs --%>
            
            <!-- Add an HTML table header row to format the results -->
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
                    <td><input value="" name="categoryid" size="3"/></td>
                    <td><input type="submit" value="Insert"/></td>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="sku" value="<%=rs.getInt("sku")%>"/>

                <%-- Get the id --%>
                <td>
                    <%=rs.getInt("sku")%>
                </td>

                <%-- Get the first name --%>
                <td>
                    <input value="<%=rs.getString("name")%>" name="name" size="15"/>
                </td>

                 <%-- Get the id --%>
                <td>
                    <input value="<%=rs.getInt("list_price")%>" name="list_price" size="5"/>
                </td>
                
                 <%-- Get the id --%>
                <td>
                    <input value="<%=rs.getInt("categoryid")%>" name="categoryid" size="3"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="update"></td>
                </form>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getInt("sku")%>" name="sku"/>
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
                rs.close();

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
        </table>
        </td>
    </tr>
</table>
</body>

</html>


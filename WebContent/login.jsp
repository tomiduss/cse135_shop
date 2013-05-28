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
             
            
            <%-- -------- HTML Form -------- --%>
           
           	<table>
				<tr>
					<td>Username</td>
				</tr>
				<tr>
					<form action="login.jsp" method="POST">
					<input type="hidden" name="action" value="login"/>
					<td><input value="" name="username" size="15" /></td>
					<td><input type="submit" value="Login" /></td>
					</form>
				</tr>
			</table>
			
            
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
            
            
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                
                String username = request.getParameter("username");
                
                String action = request.getParameter("action");
                
                rs = statement.executeQuery("SELECT * FROM shop_user WHERE username='" + username + "'");
                if (rs.next()) {
                	session.setAttribute("username", username);
                	session.setAttribute("owner", rs.getBoolean("owner"));
                	session.setAttribute("id", rs.getInt("id"));
                	
                	%>
                	<%= "Logged in as " + username + "." %>
                	<jsp:forward page="/index.jsp" />
                	<%
                	
                }
                else if (action != null && action.equals("login")) { %> <%= "Sorry, username <em>" + username + "</em> is unknown." %> <% }
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

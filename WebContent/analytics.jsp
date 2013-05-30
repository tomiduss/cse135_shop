<% int start = (int)System.currentTimeMillis(); %>
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

			<%-- -------- Open Connection Code -------- --%> <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            ResultSet product_rs = null;
            ResultSet customer_rs = null;

            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/postgres?" +
                    "user=postgres&password=leviathan");
            %>
            
            <%-- -------- Set Parameters -------- --%>   
            <%
            String row = null;
            if(request.getParameter("row") != null) row = request.getParameter("row");

            String age = null;
            int start_age = 0;
            int end_age = 0;
            if(request.getParameter("age") != null) {
            	age = request.getParameter("age");
            	String[] age_array = age.split("-");
               	start_age = Integer.parseInt(age_array[0]);
                end_age = Integer.parseInt(age_array[1]);
            }     
            
            String state = null;
            if(request.getParameter("state") != null) state = request.getParameter("state");
            
            int category_id = 0;
            if(request.getParameter("category") != null) category_id = Integer.parseInt(request.getParameter("category"));
            
            String quarter = null;
            if(request.getParameter("quarter") != null) quarter = request.getParameter("quarter");
            
            int c_offset = 0;
            if(request.getParameter("c_offset") != null) c_offset = Integer.parseInt(request.getParameter("c_offset"));
            
            int r_offset = 0;
            if(request.getParameter("r_offset") != null) r_offset = Integer.parseInt(request.getParameter("r_offset"));
            
            %>
			<%-- -------- Fetch Categories for Dropdown -------- --%>
			
			<%
			     // Create the statement
            	Statement statement = conn.createStatement();

            	// Use the created statement to SELECT
            	rs = statement.executeQuery("SELECT id, category_name FROM category");
			
            %>
            
            <%-- -------- Create Dropdowns -------- --%>
            
			<table cellpadding="5">
				<tr>
			<form action="analytics.jsp" method="GET">
				<td valign="top">
				
				<%-- Row Selector --%>
				<select name="row">
					<option value="customers">Customers</option>			
					<option <% if(row != null && row.equals("state")) { %> selected="selected" <% } %> value="state">State</option>
				</select>
				</td>
			
			<form action="analytics.jsp" method="GET">
				<td valign="top">
					
				<%-- Customer Age --%>
				<select name="age">
					<option value="0-99">All ages</option>
					<option value="0-9">0-9</option>
					<option value="10-19">10-19</option>
					<option value="20-29">20-29</option>
					<option value="30-39">30-39</option>
					<option value="40-49">40-49</option>
					<option value="50-59">50-59</option>
					<option value="60-69">60-69</option>
					<option value="70-79">70-79</option>
					<option value="20-29">80-89</option>
					<option value="30-39">90-99</option>
				</select>
				</td>
					<td valign="top">
				
				<%-- Customer State --%>
				<select name="state">
					<option value="all">All states</option>
					<option value="AL">Alabama</option>
					<option value="AK">Alaska</option>
					<option value="AZ">Arizona</option>
					<option value="AR">Arkansas</option>
					<option value="CA">California</option>
					<option value="CO">Colorado</option>
					<option value="CT">Connecticut</option>
					<option value="DE">Delaware</option>
					<option value="DC">District of Columbia</option>
					<option value="FL">Florida</option>
					<option value="GA">Georgia</option>
					<option value="HI">Hawaii</option>
					<option value="ID">Idaho</option>
					<option value="IL">Illinois</option>
					<option value="IN">Indiana</option>
					<option value="IA">Iowa</option>
					<option value="KS">Kansas</option>
					<option value="KY">Kentucky</option>
					<option value="LA">Louisiana</option>
					<option value="ME">Maine</option>
					<option value="MD">Maryland</option>
					<option value="MA">Massachusetts</option>
					<option value="MI">Michigan</option>
					<option value="MN">Minnesota</option>
					<option value="MS">Mississippi</option>
					<option value="MO">Missouri</option>
					<option value="MT">Montana</option>
					<option value="NE">Nebraska</option>
					<option value="NV">Nevada</option>
					<option value="NH">New Hampshire</option>
					<option value="NJ">New Jersey</option>
					<option value="NM">New Mexico</option>
					<option value="NY">New York</option>
					<option value="NC">North Carolina</option>
					<option value="ND">North Dakota</option>
					<option value="OH">Ohio</option>
					<option value="OK">Oklahoma</option>
					<option value="OR">Oregon</option>
					<option value="PA">Pennsylvania</option>
					<option value="RI">Rhode Island</option>
					<option value="SC">South Carolina</option>
					<option value="SD">South Dakota</option>
					<option value="TN">Tennessee</option>
					<option value="TX">Texas</option>
					<option value="UT">Utah</option>
					<option value="VT">Vermont</option>
					<option value="VA">Virginia</option>
					<option value="WA">Washington</option>
					<option value="WV">West Virginia</option>
					<option value="WI">Wisconsin</option>
					<option value="WY">Wyoming</option>
				</select>
				</td>
			
			<td valign="top">
				
				<%-- Category --%>
				<select name="category">
					<option value=0>All categories</option>
					<% while(rs.next()) { %>
							<option value=<%=rs.getInt("id")%>><%= rs.getString("category_name") %> </option>							
					<% } %>
				</select>
				</td>
				
				<td valign="top">
					
				<%-- Quarter --%>
				<select name="quarter">
					<option value="all">Full year</option>
					<option value="winter">Winter</option>
					<option value="spring">Spring</option>
					<option value="summer">Summer</option>
					<option value="fall">Fall</option>
				</select>
				</td>
			<td valign="top">
				<input type="submit" value="Run query"/>
	         	</form>
			</td>
         	</tr>
         	</table>
         	
         	<%
         	// Only run query and create table if button has been pressed
         	if(row != null) {
         	%>
         	
       	 	<!-- Create and Run Query to Find Top 10 Products Within Filter -->
         	<%
	 			//Find top products
	            String query = "SELECT sku, name, SUM(total_cost) AS total FROM ";
         		String clause = "WHERE";
         		
         		//Specify quarter or full year
         		if(quarter != null && !quarter.equals("all")) 
         			query += (quarter+"_sales ");
         		
         		//Specify category
         		if(category_id != 0) {
         			query += (clause+" categoryid="+category_id+" ");
         			clause = "AND";
         		}
         		
         		//Specify state
         		if(state != null && !state.equals("all")) {
         			query += (clause+" state='"+state+"' ");
         			clause = "AND";
         		}
	
	     		//Specify age
	     		if(age != null && !age.equals("0-99")) {
	     			query += (clause+" age >= "+start_age+" AND age <= "+end_age+" ");
	     		}
            
            	query += "GROUP BY sku, name ORDER BY total DESC LIMIT 10 OFFSET "+c_offset;
            	
            	%><p>Query: <%=query%></p><%
            			
				product_rs = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY).executeQuery(query);

         	%>
         	
         	<!-- Create and Run Query to Find Top 10 Users Within Filter -->
         	<%
	 			//Find top products
	            query = "SELECT id, username, SUM(total_cost) AS total FROM ";
         		clause = "WHERE";
         		
         		//Specify quarter or full year
         		if(quarter != null && !quarter.equals("all")) query += (quarter+"_sales ");
         		
         		//Specify category
         		if(category_id != 0) {
         			query += (clause+" categoryid="+category_id+" ");
         			clause = "AND";
         		}
         		
         		//Specify state
         		if(state != null && !state.equals("all")) {
         			query += (clause+" state='"+state+"' ");
         			clause = "AND";
         		}
	
	     		//Specify age
	     		if(age != null && !age.equals("0-99")) {
	     			query += (clause+" age >= "+start_age+" AND age <= "+end_age+" ");
	     		}
            
            	query += "GROUP BY id, username ORDER BY total DESC LIMIT 10 OFFSET "+r_offset;
            	
            	%><p>Query: <%=query%></p><%
            			
				customer_rs = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY).executeQuery(query);
         	
     		
         	%>
         	
         	<!-- Iteration Code -->

				<table border="1" cellpadding="5">
					<tr>
						<th>
						<% 
						if(row.equals("customers")) {
							%><strong>Customer</strong><%
						}
						else {
							%><strong>State</strong><%
						}
						%>
						
						</th>
						<th>Revenue</th>
						<%			
						while(product_rs.next()) {
						%>
						
						<th><%=product_rs.getString("name")%> (<%=product_rs.getInt("sku")%>)</th>
						
						<% } %>
												
						
						<!-- Next 10 Products Button -->
						<td valign="top" rowspan="12">
							<form>
								<input type="hidden" name="row" value="<%=row%>"/>
								<input type="hidden" name="age" value="<%=age%>"/>
								<input type="hidden" name="state" value="<%=state%>"/>
								<input type="hidden" name="category" value="<%=category_id%>"/>
								<input type="hidden" name="quarter" value="<%=quarter%>"/>
								<input type="hidden" name="r_offset" value="<%=r_offset%>"/>
								<input type="hidden" name="c_offset" value="<%=(c_offset + 10)%>"/>
								<input type="submit" value="Next 10"/>
							</form>
						</td>
					</tr>
         	
         	<%-- -------- Iteration Code -------- --%>
         		<% 
         		while(customer_rs.next()){
         			//iterate over rows. (outer loop)
         			//first two cells, name, total.
         			%>
         			<tr>
         				<td><%=customer_rs.getString("username")%> (<%=customer_rs.getInt("id")%>)</td>
						<td><%=customer_rs.getInt("total")%></td>
						<% 
						//Iterate over product result set.
						//Reset product result set to first.
						product_rs.beforeFirst();
						for(int i = 0; i < 10; i++){
							if(product_rs.next()){
								//Prepare statement 
								//Query: select sum(total_cost) from purchase where userid = row_user and sku = product_sku
								PreparedStatement cell_sum = conn.prepareStatement("select sum(total_cost) as sm from purchase where userid = ? and productsku = ?");
								cell_sum.setInt(1, customer_rs.getInt("id"));
								cell_sum.setInt(2, product_rs.getInt("sku"));
								ResultSet sum_rs = cell_sum.executeQuery();
								
								if(sum_rs.next()){
									%><td><%=sum_rs.getInt("sm")%></td><%
								}else{
									%><td> --- </td><%
								}
							}
							else{
								%><td > --- </td><%
							}
						}	
						%>         			
         			</tr>	
         			<%
         		}
         		%>
         		
         		<!-- Next 10 Customers Button -->
						<tr>
						<td colspan="12">
							<form>
								<input type="hidden" name="row" value="<%=row%>"/>
								<input type="hidden" name="age" value="<%=age%>"/>
								<input type="hidden" name="state" value="<%=state%>"/>
								<input type="hidden" name="category" value="<%=category_id%>"/>
								<input type="hidden" name="quarter" value="<%=quarter%>"/>
								<input type="hidden" name="c_offset" value="<%=c_offset%>"/>
								<input type="hidden" name="r_offset" value="<%=(r_offset + 10)%>"/>
								<input type="submit" value="Next 10"/>
							</form>
						</td>
						</tr>
				</table>
            <% } %>
            
            <%-- -------- Close Connection Code -------- --%>
								<%
                // Close the ResultSet
                if(rs != null) {
                	rs.close();
                }
                
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
	<tr>
		<td>
			</br>
			</br>
			<% int time = (int)(System.currentTimeMillis() - start); %>
			<p>Page load took <%=time%> milliseconds</p>
		</td>
	</tr>
	</table>	

</body>
</html>
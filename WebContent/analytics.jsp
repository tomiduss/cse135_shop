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
            
            ResultSet category_rs = null;
            ResultSet product_rs = null;
            ResultSet customer_rs = null;
            ResultSet state_rs = null;
            
            int dropdown_time = 0;
            int column_time = 0;
            int row_time = 0;
            int cell_time = 0;

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
            int start_month = 0;
            int end_month = 0;
            if(request.getParameter("quarter") != null) {
            	quarter = request.getParameter("quarter");
            	String[] quarter_array = quarter.split("-");
               	start_month = Integer.parseInt(quarter_array[0]);
                end_month = Integer.parseInt(quarter_array[1]);
            }
            
            int c_offset = 0;
            if(request.getParameter("c_offset") != null) c_offset = Integer.parseInt(request.getParameter("c_offset"));
            
            int r_offset = 0;
            if(request.getParameter("r_offset") != null) r_offset = Integer.parseInt(request.getParameter("r_offset"));
            
            %>
			<%-- -------- Fetch Categories for Dropdown -------- --%>
			<%
     	    category_rs = conn.createStatement().executeQuery("SELECT id, category_name FROM category");	
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
					<option value="0-99" <%if(age != null && age.equals("0-99")) {%>selected<%}%> >All ages</option>
					<option value="0-9" <%if(age != null && age.equals("0-9")) {%>selected<%}%> >0-9</option>
					<option value="10-19" <%if(age != null && age.equals("10-19")) {%>selected<%}%> >10-19</option>
					<option value="20-29" <%if(age != null && age.equals("20-29")) {%>selected<%}%> >20-29</option>
					<option value="30-39" <%if(age != null && age.equals("30-39")) {%>selected<%}%> >30-39</option>
					<option value="40-49" <%if(age != null && age.equals("40-49")) {%>selected<%}%> >40-49</option>
					<option value="50-59" <%if(age != null && age.equals("50-59")) {%>selected<%}%> >50-59</option>
					<option value="60-69" <%if(age != null && age.equals("60-69")) {%>selected<%}%> >60-69</option>
					<option value="70-79" <%if(age != null && age.equals("70-79")) {%>selected<%}%> >70-79</option>
					<option value="80-89" <%if(age != null && age.equals("80-89")) {%>selected<%}%> >80-89</option>
					<option value="90-99" <%if(age != null && age.equals("90-99")) {%>selected<%}%> >90-99</option>
				</select>
				</td>
					<td valign="top">
				
				<%-- Customer State --%>
				<select name="state">
					<option value="all" <%if(state != null && state.equals("all")) {%>selected<%}%> >All states</option>
					<option value="AL" <%if(state != null && state.equals("AL")) {%>selected<%}%> >Alabama</option>
					<option value="AK" <%if(state != null && state.equals("AK")) {%>selected<%}%> >Alaska</option>
					<option value="AZ" <%if(state != null && state.equals("AZ")) {%>selected<%}%> >Arizona</option>
					<option value="AR" <%if(state != null && state.equals("AR")) {%>selected<%}%> >Arkansas</option>
					<option value="CA" <%if(state != null && state.equals("CA")) {%>selected<%}%> >California</option>
					<option value="CO" <%if(state != null && state.equals("CO")) {%>selected<%}%> >Colorado</option>
					<option value="CT" <%if(state != null && state.equals("CT")) {%>selected<%}%> >Connecticut</option>
					<option value="DE" <%if(state != null && state.equals("DE")) {%>selected<%}%> >Delaware</option>
					<option value="FL" <%if(state != null && state.equals("FL")) {%>selected<%}%> >Florida</option>
					<option value="GA" <%if(state != null && state.equals("GA")) {%>selected<%}%> >Georgia</option>
					<option value="HI" <%if(state != null && state.equals("HI")) {%>selected<%}%> >Hawaii</option>
					<option value="ID" <%if(state != null && state.equals("ID")) {%>selected<%}%> >Idaho</option>
					<option value="IL" <%if(state != null && state.equals("IL")) {%>selected<%}%> >Illinois</option>
					<option value="IN" <%if(state != null && state.equals("IN")) {%>selected<%}%> >Indiana</option>
					<option value="IA" <%if(state != null && state.equals("IA")) {%>selected<%}%> >Iowa</option>
					<option value="KS" <%if(state != null && state.equals("KS")) {%>selected<%}%> >Kansas</option>
					<option value="KY" <%if(state != null && state.equals("KY")) {%>selected<%}%> >Kentucky</option>
					<option value="LA" <%if(state != null && state.equals("LA")) {%>selected<%}%> >Louisiana</option>
					<option value="ME" <%if(state != null && state.equals("ME")) {%>selected<%}%> >Maine</option>
					<option value="MD" <%if(state != null && state.equals("MD")) {%>selected<%}%> >Maryland</option>
					<option value="MA" <%if(state != null && state.equals("MA")) {%>selected<%}%> >Massachusetts</option>
					<option value="MI" <%if(state != null && state.equals("MI")) {%>selected<%}%> >Michigan</option>
					<option value="MN" <%if(state != null && state.equals("MN")) {%>selected<%}%> >Minnesota</option>
					<option value="MS" <%if(state != null && state.equals("MS")) {%>selected<%}%> >Mississippi</option>
					<option value="MO" <%if(state != null && state.equals("MO")) {%>selected<%}%> >Missouri</option>
					<option value="MT" <%if(state != null && state.equals("MT")) {%>selected<%}%> >Montana</option>
					<option value="NE" <%if(state != null && state.equals("NE")) {%>selected<%}%> >Nebraska</option>
					<option value="NV" <%if(state != null && state.equals("NV")) {%>selected<%}%> >Nevada</option>
					<option value="NH" <%if(state != null && state.equals("NH")) {%>selected<%}%> >New Hampshire</option>
					<option value="NJ" <%if(state != null && state.equals("NJ")) {%>selected<%}%> >New Jersey</option>
					<option value="NM" <%if(state != null && state.equals("NM")) {%>selected<%}%> >New Mexico</option>
					<option value="NY" <%if(state != null && state.equals("NY")) {%>selected<%}%> >New York</option>
					<option value="NC" <%if(state != null && state.equals("NC")) {%>selected<%}%> >North Carolina</option>
					<option value="ND" <%if(state != null && state.equals("ND")) {%>selected<%}%> >North Dakota</option>
					<option value="OH" <%if(state != null && state.equals("OH")) {%>selected<%}%> >Ohio</option>
					<option value="OK" <%if(state != null && state.equals("OK")) {%>selected<%}%> >Oklahoma</option>
					<option value="OR" <%if(state != null && state.equals("OR")) {%>selected<%}%> >Oregon</option>
					<option value="PA" <%if(state != null && state.equals("PA")) {%>selected<%}%> >Pennsylvania</option>
					<option value="RI" <%if(state != null && state.equals("RI")) {%>selected<%}%> >Rhode Island</option>
					<option value="SC" <%if(state != null && state.equals("SC")) {%>selected<%}%> >South Carolina</option>
					<option value="SD" <%if(state != null && state.equals("SD")) {%>selected<%}%> >South Dakota</option>
					<option value="TN" <%if(state != null && state.equals("TN")) {%>selected<%}%> >Tennessee</option>
					<option value="TX" <%if(state != null && state.equals("TX")) {%>selected<%}%> >Texas</option>
					<option value="UT" <%if(state != null && state.equals("UT")) {%>selected<%}%> >Utah</option>
					<option value="VT" <%if(state != null && state.equals("VT")) {%>selected<%}%> >Vermont</option>
					<option value="VA" <%if(state != null && state.equals("VA")) {%>selected<%}%> >Virginia</option>
					<option value="WA" <%if(state != null && state.equals("WA")) {%>selected<%}%> >Washington</option>
					<option value="WV" <%if(state != null && state.equals("WV")) {%>selected<%}%> >West Virginia</option>
					<option value="WI" <%if(state != null && state.equals("WI")) {%>selected<%}%> >Wisconsin</option>
					<option value="WY" <%if(state != null && state.equals("WY")) {%>selected<%}%> >Wyoming</option>
				</select>
				</td>
			
			<td valign="top">
				<%-- Category --%>
				<select name="category">
					<option value=0 <%if(category_id == 0) {%>selected<%}%> >All categories</option>
					<% while(category_rs.next()) { %>
							<option value=<%=category_rs.getInt("id")%> <%if(category_id == category_rs.getInt("id")) {%>selected<%}%>><%=category_rs.getString("category_name") %> </option>							
					<% } %>
				</select>
				</td>
				
				<td valign="top">	
				<%-- Quarter --%>
				<select name="quarter">
					<option value="1-12" <%if(quarter != null && quarter.equals("1-12")) {%>selected<%}%>>Full year</option>
					<option value="12-2" <%if(quarter != null && quarter.equals("12-2")) {%>selected<%}%>>Winter</option>
					<option value="3-5" <%if(quarter != null && quarter.equals("3-5")) {%>selected<%}%>>Spring</option>
					<option value="6-8" <%if(quarter != null && quarter.equals("6-8")) {%>selected<%}%>>Summer</option>
					<option value="9-11" <%if(quarter != null && quarter.equals("9-11")) {%>selected<%}%>>Fall</option>
				</select>
				</td>
			<td valign="top">
				<input type="submit" value="Run query"/>
	         	</form>
			</td>
         	</tr>
         	</table>
         	
         	<%
         	//Set time it took so far
         	dropdown_time = (int)(System.currentTimeMillis() - start);
         	// Only run query and create table if button has been pressed
         	if(row != null) {
         	%>
         	
       	 	<!-- Create and Run Query to Find Top 10 Products Within Filter -->
         	<%
	 			//Find top products
	            String query = "SELECT sku, name, SUM(total_cost) AS total FROM year_sales ";
         		String clause = "WHERE";

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
	     			clause = "AND";
	     		}
	     		
	     		//Specify quarter
	     		if(quarter != null) {
	     			query += (clause+" EXTRACT(MONTH FROM date) >="+start_month+" AND EXTRACT(MONTH FROM date) <="+end_month+" ");
	     		}
	     		   
            
            	query += "GROUP BY sku, name ORDER BY total DESC LIMIT 10 OFFSET "+c_offset;
            	
            	%><p>Query: <%=query%></p><%
            			
				product_rs = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY).executeQuery(query);
            	
            	//Set time it took so far
             	row_time = (int)(System.currentTimeMillis() - start - dropdown_time);

         	%>
         	
         	<!-- Create and Run Query to Find Top 10 Users Within Filter -->
         	<%
         		if(row.equals("customers")) {
	 			//Find top products
	            query = "SELECT id, username, SUM(total_cost) AS total FROM year_sales ";
         		clause = "WHERE";
         		
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
	     		
	     		//Specify quarter
	     		if(quarter != null) {
	     			query += (clause+" EXTRACT(MONTH FROM date) >="+start_month+" AND EXTRACT(MONTH FROM date) <="+end_month+" ");
	     		}
            
            	query += "GROUP BY id, username ORDER BY total DESC LIMIT 10 OFFSET "+r_offset;
            	
            	%><p>Query: <%=query%></p><%
            			
				customer_rs = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY).executeQuery(query);
            	
            	//Set time it took so far
             	column_time = (int)(System.currentTimeMillis() - start - dropdown_time - row_time);
            	
         		} else {
         	
     		
         	%>
         	
         	<!-- Create and Run Query to Find Top 10 States Within Filter -->
         	<%
	 			//Find top products
	            query = "SELECT state, SUM(total_cost) AS total FROM year_sales ";
         		clause = "WHERE";
         		
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
	     		
	     		//Specify quarter
	     		if(quarter != null) {
	     			query += (clause+" EXTRACT(MONTH FROM date) >="+start_month+" AND EXTRACT(MONTH FROM date) <="+end_month+" ");
	     		}
            
            	query += "GROUP BY state ORDER BY total DESC LIMIT 10 OFFSET "+r_offset;
            	
            	%><p>Query: <%=query%></p><%
            			
				state_rs = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY).executeQuery(query);
         		
            	//Set time it took so far
             	column_time = (int)(System.currentTimeMillis() - start - dropdown_time - row_time);
         		}
         	%>
         	
         	<!-- Iteration Code for Products -->

				<table border="1" cellpadding="5">
					<tr>
						<th>
						<% 
						if(row.equals("customers")) {
							%><strong><p>Customer</p></strong><%
						}
						else {
							%><strong><p>State</p></strong><%
						}
						%>
						
						</th>
						<th><p>Revenue</p></th>
						<%			
						while(product_rs.next()) {
						%>
						
						<th><p><%=product_rs.getString("name")%> (<%=product_rs.getInt("sku")%>)</p></th>
						
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
         	
         	<!-- Iteration Code for Customers -->
         		<% 
         		if(customer_rs != null) {
	         		while(customer_rs.next()){
	         			//iterate over rows. (outer loop)
	         			//first two cells, name, total.
	         			%>
	         			<tr>
	         				<td><p><%=customer_rs.getString("username")%> (<%=customer_rs.getInt("id")%>)</p></td>
							<td><p><%=customer_rs.getInt("total")%></p></td>
							<% 
							//Iterate over product result set.
							//Reset product result set to first.
							product_rs.beforeFirst();
							for(int i = 0; i < 10; i++){
								if(product_rs.next()){
									//Prepare statement 
									//Query: select sum(total_cost) from purchase where userid = row_user and sku = product_sku
									PreparedStatement cell_sum = conn.prepareStatement("select quantity, sum(total_cost) as sm from purchase where userid = ? and productsku = ? group by quantity");
									cell_sum.setInt(1, customer_rs.getInt("id"));
									cell_sum.setInt(2, product_rs.getInt("sku"));
									ResultSet sum_rs = cell_sum.executeQuery();
									
									if(sum_rs.next()){
										%><td><p><%=sum_rs.getInt("sm")%> (qty:<%=sum_rs.getInt("quantity") %>)</p></td><%
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
         		//Set time it took so far
             	cell_time = (int)(System.currentTimeMillis() - start - dropdown_time - row_time - column_time);
         		}
	         	%>
         		<!-- Iteration Code for States -->
         		<%
	         	if(state_rs != null) {
	         		while(state_rs.next()){
	         			//iterate over rows. (outer loop)
	         			//first two cells, name, total.
	         			%>
	         			<tr>
	         				<td><p><%=state_rs.getString("state")%></p></td>
							<td><p><%=state_rs.getLong("total")%></p></td>
							<% 
							//Iterate over product result set.
							//Reset product result set to first.
							product_rs.beforeFirst();
							for(int i = 0; i < 10; i++){
								if(product_rs.next()){
									//Prepare statement 
									//Query: select sum(total_cost) from purchase where userid = row_user and sku = product_sku
									PreparedStatement cell_sum = conn.prepareStatement("select sum(total_cost) as sm from year_sales where state = ? and sku = ?");
									cell_sum.setString(1, state_rs.getString("state"));
									cell_sum.setInt(2, product_rs.getInt("sku"));
									ResultSet sum_rs = cell_sum.executeQuery();
									
									if(sum_rs.next()){
										%><td><p><%=sum_rs.getInt("sm")%></p></td><%
									}else{
										%><td><p> --- </p></td><%
									}
								}
								else{
									%><td><p> --- </p></td><%
								}
							}	
							%>         			
	         			</tr>	
	         			<%
	         		} 
         		//Set time it took so far
             	cell_time = (int)(System.currentTimeMillis() - start - dropdown_time - row_time - column_time);	
	         	}
	         		%>
         		
         		<!-- Next 10 Customers/States Button -->
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
                // Close the ResultSets
                if (category_rs != null) {
                    category_rs.close();
                }
                if (product_rs != null) {
                    product_rs.close();
                }
                if (customer_rs != null) {
                    customer_rs.close();
                }
                if (state_rs != null) {
                    state_rs.close();
                }
			
                // Close the PreparedStatement
                if(pstmt != null) {
                    pstmt.close();
                }

                // Close the Connection
                conn.close();
                
            } catch (SQLException e) {
            	// Provide the user with an error message if there's an exception
                %><p>SQL Error Message: <%=e.getMessage()%></br></br>SQL State: <%=e.getSQLState()%></p><%
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (category_rs != null) {
                    try {
                    	category_rs.close();
                    } catch (SQLException e) { } // Ignore
                    category_rs = null;
                }
                if (product_rs != null) {
                    try {
                    	product_rs.close();
                    } catch (SQLException e) { } // Ignore
                    product_rs = null;
                }
                if (customer_rs != null) {
                    try {
                    	customer_rs.close();
                    } catch (SQLException e) { } // Ignore
                    customer_rs = null;
                }
                if (state_rs != null) {
                    try {
                    	state_rs.close();
                    } catch (SQLException e) { } // Ignore
                    state_rs = null;
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
			<!-- Show Load Time -->
			<% int total_time = (int)(System.currentTimeMillis() - start); %>
			<p>
			Loading menus and dropdowns took <%=dropdown_time%> ms</br>
			Loading top customers/states took <%=column_time%> ms</br>
			Loading top products took <%=row_time%> ms</br>
			Filling cells took <%=cell_time%> ms</br>
			Other loading took <%=total_time - (dropdown_time+column_time+row_time+cell_time)%> ms</br>
			Total page load took <%=total_time%> ms</p>
			
		</td>
	</tr>
	</table>	

</body>
</html>
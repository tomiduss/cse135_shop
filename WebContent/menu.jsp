<table cellpadding="5">
	<tr>
		<td colspan=11>
			<%  if(session.getAttribute("username") != null) { %> Hello, <%= session.getAttribute("username") + "!"%>
			<% } %>
		</td>
	<tr>

		<%  if(session.getAttribute("username") == null) { %>
		<td><a href="signup.jsp">Sign up</a></td>
		<% } %>

		<%  if(session.getAttribute("username") == null) { %>
		<td><a href="login.jsp">Login</a></td>
		<% } %>

		<%  if(session.getAttribute("username") != null) { %>
		<td><a href="logout.jsp">Logout</a></td>
		<% } %>

		<td><a href="browse.jsp">Browse</a></td>
		<td><a href="cart.jsp">Shopping Cart</a></td>

		<% if(session.getAttribute("owner") != null) { if(session.getAttribute("owner").toString().equals("true")) { %>
		<td width="25px"></td>
		<td><b>Owner tools:</b></td>
		<td><a href="products.jsp">Edit products</a></td>
		<td><a href="categories.jsp">Edit categories</a></td>
		<td><a href="analytics.jsp">Analytics</a></td>
		<td><a href="live.jsp">Live stats</a></td>
		<% } }%>
	</tr>
</table>
</br>
</br>
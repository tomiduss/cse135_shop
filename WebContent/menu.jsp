<head>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<table cellpadding="5">
<tr>
<td colspan=8>
<%  if(session.getAttribute("username") != null) {
%>
Hello, <%= session.getAttribute("username") + "!" %>
<% } %>
</td>
<tr>
<td><a href="signup.jsp">Sign up</a></td>
<td><a href="login.jsp">Login</a></td>
<td><a href="browse.jsp">Browse</a></td>
<td><a href="cart.jsp">Shopping Cart</a></td>
<td width="25px"></td>
<td><b>Owner tools:</b></td>
<td><a href="products.jsp">Edit products</a></td>
<td><a href="categories.jsp">Edit categories</a></td>
</tr>
</table>
</br>
</br>
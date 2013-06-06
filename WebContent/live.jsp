<html>
<head>
<head>
<link rel="stylesheet" type="text/css" href="style.css">
<script type="text/javascript">

//Interval function that runs the script every 2 seconds
window.setInterval("javascript:show();",100000);
function createXMLHttpRequest(){
  // Provide the XMLHttpRequest class for IE 5.x-6.x:
  if( typeof XMLHttpRequest == "undefined" ) XMLHttpRequest = function() {
    try { return new ActiveXObject("Msxml2.XMLHTTP.6.0") } catch(e) {}
    try { return new ActiveXObject("Msxml2.XMLHTTP.3.0") } catch(e) {}
    try { return new ActiveXObject("Msxml2.XMLHTTP") } catch(e) {}
    try { return new ActiveXObject("Microsoft.XMLHTTP") } catch(e) {}
    throw new Error( "This browser does not support XMLHttpRequest." )
  };
  return new XMLHttpRequest();
}

var AJAX = createXMLHttpRequest();

function handler() {
  if(AJAX.readyState == 4 && AJAX.status == 200) {
      var json = eval('(' + AJAX.responseText +')');
      alert('Success. Result: name => ' + json.name + ',' + 'balance => ' + json.balance);
  }else if (AJAX.readyState == 4 && AJAX.status != 200) {
    alert('Something went wrong...');
  }
}

function show(){
  AJAX.onreadystatechange = handler;
  AJAX.open("GET", "log.jsp");
  AJAX.send("");
};
</script>
</head>

<body onload="show()">
<div id="message"></div>
<div id="message2"></div>
<div id="message3"></div>

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
            ResultSet category_rs = null;
            ResultSet state_rs = null;
            
            try {
	            // Registering Postgresql JDBC driver with the DriverManager
	            Class.forName("org.postgresql.Driver");
	
	            // Open a connection to the database using DriverManager
	            conn = DriverManager.getConnection(
	                "jdbc:postgresql://localhost/postgres?" +
	                "user=postgres&password=leviathan");
            
            %>
    		<%-- -------- Fetch Categories for Dropdown -------- --%>
			<%
            	category_rs = conn.createStatement().executeQuery("SELECT id, category_name FROM category ORDER BY category_name ASC");
            %>
            <%-- State Array --%>
            <%
            String[] states = {	"AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DE", "FL", "GA",
            					"HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD",
            					"ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH",
            					"NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC",
            					"SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY" };
            %>
            <%-- Create Table --%>
            
            <table cellpadding="5" border="1">
            	<tr>
            		<%-- States as columns --%>
	            	<td><p><strong>Category</strong></p></td>
	            	<%
	            	for(int i=0; i<states.length; i++) {
	            		%><td><p><%=states[i]%></p></td>
	            		<%
	            	}	            		
	      	 %></tr>
	            <%
	            while(category_rs.next()) {
	            	%><tr>
	            		<td><p><%=category_rs.getString("category_name")%></p></td>
	            		<%
	            		for(int i=0; i<states.length; i++) {
	            		%><td style="font-family:Verdana, Geneva, sans-serif;
	font-size:10px;" id="<%=category_rs.getInt("id")%>-<%=states[i]%>"></td>
	            		<%
	            		}
	            }
	            %>
	            
            </table>
            
          	<%-- -------- Close Connection Code -------- --%>
			<%
                // Close the ResultSets
                if (category_rs != null) {
                    category_rs.close();
                }

                // Close the Connection
                conn.close();
                
            } catch (SQLException e) {
            	// Provide the user with an error message if there's an exception
                %><p>SQL Error Message: <%=e.getMessage()%><br><br>SQL State: <%=e.getSQLState()%></p><%
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
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>
            
    	</td>
    </tr>      
</table>
</body>
</html>
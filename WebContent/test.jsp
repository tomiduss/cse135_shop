<%
java.util.Date date = new java.util.Date(System.currentTimeMillis());
java.sql.Timestamp timestamp = new java.sql.Timestamp(date.getTime());
%>
<%=timestamp.toString().substring(0,10)%>
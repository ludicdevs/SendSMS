<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%  
	UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
%>

<div id="header">
	<div id="logo">
		<span id="left">Send</span>
		<span id="right">SMS</span>
	</div>
	
	<div id="user-info">
		<div id="logout">
				<a class="green-btn" id="logout-btn" 
					href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Log out</a>
		</div>
	</div>
	<div id="user-id"> Hello, <%= user.getNickname() %>! </div>
</div>

<%
	if (request.getAttribute("sms-sent") != null || request.getAttribute("error") != null) {
%>
		<% if (request.getAttribute("error") != null) { %>
			<div id="sms-alert-err">
				<div id="close"> x </div>
				<span class="alert-txt"> An error occurred: <%= request.getAttribute("error") %>. </span>
			</div>
		<% } else { %>
			<div id="sms-alert">
				<div id="close"> x </div>
				<span class="alert-txt"> The message has been sent to <%= request.getAttribute("phoneNo") %>. </span>
			</div>
		<% } 
	}
  }
%>
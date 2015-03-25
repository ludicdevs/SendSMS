<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>

<%  
	UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user == null) {
    	response.sendRedirect("/login");
    }
%>

<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/stylesheets/core.css"/>
		<script src="https://code.jquery.com/jquery-2.1.3.min.js"></script>
		<script src="/script/core.js"></script>
	</head>
	
	<body>
		<jsp:include page="/header.jsp" />
		<form method="POST" action="/sendSms">
			<div id="send-sms">
				<div class="row"> 
					<input id="prefix" name="prefix" type="text" value="+40" disabled/>
					<input id="destination" name="destination" type="text" minlength="9" maxlength="9" />
					<input id="send-btn" class="green-btn" type="submit" value="Send" />
				</div>
				
				<div class="row">
					<textarea id="message" name="message" rows="7" cols="25" maxlength="150"></textarea>
				</div>
			</div>
			
			<div id="old-messages">
				<%
				 	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			    	Key outboxKey = KeyFactory.createKey("Outbox", user.getNickname());
			    	Query query = new Query("Message", outboxKey).addSort("date", Query.SortDirection.DESCENDING);
			        List<Entity> messages = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
			        if (!messages.isEmpty()) {
				%>
					<div id="sent-messages-header">
						Sent messages:
					</div>
					<div id="sent-messages">
						<% 
							for (Entity message : messages) {
						%>
							<div class="sent-msg">
								<div class="sent-date">
									<span class="msg-label">Date:</span> <%= message.getProperty("date") %> 
							 	</div>
								<div class="destination">
									<span class="msg-label">Destination:</span> <%= message.getProperty("destination") %> 
								</div>
								<div class="msg-body"> <%= message.getProperty("message") %> </div>
							</div>
						<% 
							}
            			%>
					</div>
				<% 
			        } 
		        %>
			</div>
		</form>
	</body>
</html>
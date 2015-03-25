package com.ludicdev.pcd.sms;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.twilio.sdk.TwilioRestClient;
import com.twilio.sdk.TwilioRestException;
import com.twilio.sdk.resource.factory.SmsFactory;
import com.twilio.sdk.resource.instance.Account;

@SuppressWarnings("serial")
public class TwilioServlet extends HttpServlet {
	
	public static final String ACCOUNT_SID = "ACddcf15ae3e69620a5d76509560df292b";
    public static final String AUTH_TOKEN = "c7cba149c7d6d3eb46395b607dcee057";
 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        verifyUserStatus(request, response);
    	
    	TwilioRestClient client = new TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN);
        Account account = client.getAccount();
        
        SMS msg = SMS.fromRequest(request);
        sendSms(account, msg);
        addSmsToDataStore(msg);
        
        request.setAttribute("sms-sent", true);
        request.setAttribute("phoneNo", msg.getDestination());
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/sendSms.jsp");
        dispatcher.forward(request, response);
    }
    
    private void addSmsToDataStore(SMS msg) {
    	UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        Key outboxKey = KeyFactory.createKey("Outbox", user.getNickname());
        Entity message = new Entity("Message", outboxKey);
        message.setProperty("date", new Date());
        message.setProperty("destination", msg.getDestination());
        message.setProperty("message", msg.getMessage());
        
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(message);

	}

	private void verifyUserStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	UserService userService = UserServiceFactory.getUserService();
        String thisURL = request.getRequestURI();
        response.setContentType("text/html");
        if (request.getUserPrincipal() == null) {
            response.getWriter().println("<p>Please <a href=\"" + userService.createLoginURL(thisURL) + "\">sign in</a>.</p>");
        }
    }
    
    private void sendSms(Account account, SMS msg) {
    	try {
	    	SmsFactory smsFactory = account.getSmsFactory();
	        Map<String, String> smsParams = new HashMap<String, String>();
	        smsParams.put("To", msg.getDestination()); 
	        smsParams.put("From", msg.getFrom());
	        smsParams.put("Body", msg.getMessage());
	        
	        smsFactory.create(smsParams);
    	} catch (TwilioRestException ex) {
    		ex.printStackTrace();
    	}
    }
    
    

	
}

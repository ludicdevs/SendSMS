package com.ludicdev.pcd.sms;

import javax.servlet.http.HttpServletRequest;

public class SMS {

	private static final String PREFIX = "+40";
	private static final String FROM = "(205) 289-7067";
	
	private String destination;
	private String message;
	
	public static SMS fromRequest(HttpServletRequest request) {
		SMS msg = new SMS();
		String phoneNo = request.getParameter("destination");
		msg.setDestination(PREFIX + phoneNo);
		msg.setMessage(request.getParameter("message"));
		return msg;
	}
	
	private SMS() { }
	
	public String getFrom() {
		return FROM;
	}
	
	public String getDestination() {
		return destination;
	}
	
	public void setDestination(String to) {
		this.destination = to;
	}
	
	public String getMessage() {
		return message;
	}
	
	public void setMessage(String message) {
		this.message = message;
	}
}

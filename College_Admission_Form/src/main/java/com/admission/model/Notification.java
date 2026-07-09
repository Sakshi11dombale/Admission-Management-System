package com.admission.model;
import java.sql.Timestamp;

public class Notification {
    private int id, userId;
    private String title, message, userName;
    private boolean read;
    private Timestamp createdAt;

    public Notification() {}
    public Notification(int userId, String title, String message) {
        this.userId = userId; this.title = title; this.message = message;
    }

    public int getId() { 
    	return id; 
    	} 
    
    public void setId(int id) { 
    	this.id = id; 
    	}
    
    public int getUserId() { 
    	return userId; 
    	} 
    
    public void setUserId(int u) { 
    	this.userId = u; 
    	}
    
    public String getTitle() {
    	return title; 
    	} 
    
    public void setTitle(String t) { 
    	this.title = t; 
    	}
    
    public String getMessage() { 
    	return message; 
    	} 
    
    public void setMessage(String m) { 
    	this.message = m; 
    	}
    
    public String getUserName() { 
    	return userName; 
    	} 
    
    public void setUserName(String u) { 
    	this.userName = u; 
    	}
    
    public boolean isRead() { 
    	return read; 
    	} 
    
    public void setRead(boolean r) { 
    	this.read = r; 
    	}
    
    public Timestamp getCreatedAt() { 
    	return createdAt; 
    	}
    
    public void setCreatedAt(Timestamp t) { 
    	this.createdAt = t; 
    	}
}

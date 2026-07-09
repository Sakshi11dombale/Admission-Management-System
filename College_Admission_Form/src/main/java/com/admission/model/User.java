package com.admission.model;
import java.sql.Timestamp;

public class User {
    private int id;
    private String username, password, email, role, fullName, phone;
    private Timestamp createdAt;

    public User() {}

    public int getId() { 
    	return id; 
    	} 
    
    public void setId(int id) { 
    	this.id = id; 
    	}
    
    public String getUsername() { 
    	return username; 
    	}
    
    public void setUsername(String u) { 
    	this.username = u;
    	}
    
    public String getPassword() { 
    	return password; 
    	} 
    
    public void setPassword(String p) { 
    	this.password = p; 
    	}
    
    public String getEmail() { 
    	return email; 
    	} 
    
    public void setEmail(String e) { 
    	this.email = e; 
    	}
    
    public String getRole() {
    	return role; 
    	} 
    
    public void setRole(String r) {
    	this.role = r; 
    	}
    
    public String getFullName() {
    	return fullName; 
    	} 
    
    public void setFullName(String f) { 
    	this.fullName = f; 
    	}
    
    public String getPhone() { 
    	return phone; 
    	}
    
    public void setPhone(String p) {
    	this.phone = p; 
    	}
    
    public Timestamp getCreatedAt() { 
    	return createdAt; 
    	}
    
    public void setCreatedAt(Timestamp t) { 
    	this.createdAt = t; 
    	}
    
    public boolean isAdmin() {
    	return "ADMIN".equals(this.role); 
    	}
}
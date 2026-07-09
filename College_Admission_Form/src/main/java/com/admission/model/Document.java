package com.admission.model;
import java.sql.Timestamp;

public class Document {
    private int id, applicationId;
    private String docType, originalName, storedName, mimeType;
    private long fileSize;
    private boolean verified;
    private Timestamp uploadedAt;

    public int getId() { 
    	return id; 
    	} 
    
    public void setId(int id) { 
    	this.id = id;
    	}
    
    public int getApplicationId() { 
    	return applicationId; 
    	}
    
    public void setApplicationId(int a) {
    	this.applicationId = a; 
    	}
   
    public String getDocType() { 
    	return docType; 
    	} 
    
    public void setDocType(String d) { 
    	this.docType = d; 
    	}
    
    public String getOriginalName() {
    	return originalName; 
    	}
    
    public void setOriginalName(String o) {
    	this.originalName = o;
    	}
    
    public String getStoredName() {
    	return storedName; 
    	} 
    
    public void setStoredName(String s) { 
    	this.storedName = s; 
    	}
    
    public String getMimeType() { 
    	return mimeType; 
    	} 
    
    public void setMimeType(String m) { 
    	this.mimeType = m; 
    	}
    
    public long getFileSize() {
    	return fileSize; 
    	} 
    
    public void setFileSize(long f) { 
    	this.fileSize = f; 
    	}
    
    public boolean isVerified() { 
    	return verified;
    	} 
    
    public void setVerified(boolean v) { 
    	this.verified = v; 
    	}
   
    public Timestamp getUploadedAt() {
    	return uploadedAt; 
    	}

    public void setUploadedAt(Timestamp t) { 
    	this.uploadedAt = t; 
    	}
    
    public String getFileSizeFormatted() {
        if (fileSize < 1024) return fileSize + " B";
        else if (fileSize < 1024*1024) return String.format("%.1f KB", fileSize/1024.0);
        else return String.format("%.1f MB", fileSize/(1024.0*1024));
    }
}

package com.election.model;

import java.sql.Timestamp;
import java.util.Date;

/**
 * Election model class
 */
public class Election {
    private int electionId;
    private String title;
    private String description;
    private Date startDate;
    private Date endDate;
    private int createdBy;
    private Timestamp creationDate;
    private boolean active;
    
    // Constructors
    public Election() {
    }
    
    public Election(int electionId, String title, String description, Date startDate, 
                   Date endDate, int createdBy, Timestamp creationDate, boolean active) {
        this.electionId = electionId;
        this.title = title;
        this.description = description;
        this.startDate = startDate;
        this.endDate = endDate;
        this.createdBy = createdBy;
        this.creationDate = creationDate;
        this.active = active;
    }
    
    // Getters and setters
    public int getElectionId() {
        return electionId;
    }
    
    public void setElectionId(int electionId) {
        this.electionId = electionId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public int getCreatedBy() {
        return createdBy;
    }
    
    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }
    
    public Timestamp getCreationDate() {
        return creationDate;
    }
    
    public void setCreationDate(Timestamp creationDate) {
        this.creationDate = creationDate;
    }
    
    public boolean isActive() {
        return active;
    }
    
    public void setActive(boolean active) {
        this.active = active;
    }
} 
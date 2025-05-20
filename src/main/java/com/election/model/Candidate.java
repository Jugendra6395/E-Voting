package com.election.model;

/**
 * Candidate model class
 */
public class Candidate {
    private int candidateId;
    private int electionId;
    private String name;
    private String description;
    
    // Constructors
    public Candidate() {
    }
    
    public Candidate(int candidateId, int electionId, String name, String description) {
        this.candidateId = candidateId;
        this.electionId = electionId;
        this.name = name;
        this.description = description;
    }
    
    // Getters and setters
    public int getCandidateId() {
        return candidateId;
    }
    
    public void setCandidateId(int candidateId) {
        this.candidateId = candidateId;
    }
    
    public int getElectionId() {
        return electionId;
    }
    
    public void setElectionId(int electionId) {
        this.electionId = electionId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
} 
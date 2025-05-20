package com.election.model;

import java.sql.Timestamp;

/**
 * Vote model class
 */
public class Vote {
    private int voteId;
    private int electionId;
    private int voterId;
    private int candidateId;
    private Timestamp voteTimestamp;
    
    // Constructors
    public Vote() {
    }
    
    public Vote(int voteId, int electionId, int voterId, int candidateId, Timestamp voteTimestamp) {
        this.voteId = voteId;
        this.electionId = electionId;
        this.voterId = voterId;
        this.candidateId = candidateId;
        this.voteTimestamp = voteTimestamp;
    }
    
    // Getters and setters
    public int getVoteId() {
        return voteId;
    }
    
    public void setVoteId(int voteId) {
        this.voteId = voteId;
    }
    
    public int getElectionId() {
        return electionId;
    }
    
    public void setElectionId(int electionId) {
        this.electionId = electionId;
    }
    
    public int getVoterId() {
        return voterId;
    }
    
    public void setVoterId(int voterId) {
        this.voterId = voterId;
    }
    
    public int getCandidateId() {
        return candidateId;
    }
    
    public void setCandidateId(int candidateId) {
        this.candidateId = candidateId;
    }
    
    public Timestamp getVoteTimestamp() {
        return voteTimestamp;
    }
    
    public void setVoteTimestamp(Timestamp voteTimestamp) {
        this.voteTimestamp = voteTimestamp;
    }
} 
package com.election.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.election.model.Vote;
import com.election.dao.DBUtil;

public class VoteDAO {
    
    /**
     * Checks if a user has already voted in a specific election
     * 
     * @param electionId the election ID
     * @param voterId the voter ID
     * @return true if the user has already voted, false otherwise
     */
    public boolean hasVoted(int electionId, int voterId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean hasVoted = false;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM votes WHERE election_id = ? AND voter_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, electionId);
            stmt.setInt(2, voterId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                hasVoted = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return hasVoted;
    }
    
    /**
     * Records a vote in the database
     * 
     * @param vote the vote to cast
     * @return true if successful, false otherwise
     */
    public boolean castVote(Vote vote) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO votes (election_id, voter_id, candidate_id, vote_timestamp) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, vote.getElectionId());
            stmt.setInt(2, vote.getVoterId());
            stmt.setInt(3, vote.getCandidateId());
            stmt.setTimestamp(4, new java.sql.Timestamp(new Date().getTime()));
            
            int rowsAffected = stmt.executeUpdate();
            success = rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        
        return success;
    }
    
    /**
     * Gets the vote count for each candidate in an election
     * 
     * @param electionId the election ID
     * @return a map of candidate ID to vote count
     */
    public Map<Integer, Integer> getVoteCountByCandidate(int electionId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Map<Integer, Integer> voteCounts = new HashMap<>();
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT candidate_id, COUNT(*) as vote_count FROM votes WHERE election_id = ? GROUP BY candidate_id";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, electionId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                int candidateId = rs.getInt("candidate_id");
                int voteCount = rs.getInt("vote_count");
                voteCounts.put(candidateId, voteCount);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return voteCounts;
    }
    
    /**
     * Gets the total number of votes cast in an election
     * 
     * @param electionId the election ID
     * @return the total vote count
     */
    public int getTotalVoteCount(int electionId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int totalVotes = 0;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM votes WHERE election_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, electionId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                totalVotes = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return totalVotes;
    }
    
    /**
     * Utility method to close database resources
     */
    private void closeResources(Connection conn, PreparedStatement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 
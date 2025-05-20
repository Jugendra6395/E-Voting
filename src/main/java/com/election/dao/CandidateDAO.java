package com.election.dao;

import com.election.model.Candidate;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Candidate entities
 */
public class CandidateDAO {
    
    /**
     * Adds a new candidate
     * @param candidate the Candidate object to add
     * @return true if successful, false otherwise
     */
    public boolean addCandidate(Candidate candidate) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO candidates (election_id, name, description) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, candidate.getElectionId());
            stmt.setString(2, candidate.getName());
            stmt.setString(3, candidate.getDescription());
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        
        return success;
    }
    
    /**
     * Gets a candidate by ID
     * @param candidateId the candidate ID
     * @return Candidate object if found, null otherwise
     */
    public Candidate getCandidateById(int candidateId) {
        Candidate candidate = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM candidates WHERE candidate_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, candidateId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                candidate = extractCandidateFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return candidate;
    }
    
    /**
     * Gets all candidates for a specific election
     * @param electionId the election ID
     * @return List of candidates for the election
     */
    public List<Candidate> getCandidatesByElection(int electionId) {
        List<Candidate> candidates = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM candidates WHERE election_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, electionId);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                candidates.add(extractCandidateFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return candidates;
    }
    
    /**
     * Updates a candidate
     * @param candidate the Candidate object to update
     * @return true if successful, false otherwise
     */
    public boolean updateCandidate(Candidate candidate) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE candidates SET name = ?, description = ? WHERE candidate_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, candidate.getName());
            stmt.setString(2, candidate.getDescription());
            stmt.setInt(3, candidate.getCandidateId());
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        
        return success;
    }
    
    /**
     * Deletes a candidate
     * @param candidateId the candidate ID to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteCandidate(int candidateId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM candidates WHERE candidate_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, candidateId);
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, null);
        }
        
        return success;
    }
    
    /**
     * Helper method to extract Candidate object from ResultSet
     */
    private Candidate extractCandidateFromResultSet(ResultSet rs) throws SQLException {
        Candidate candidate = new Candidate();
        candidate.setCandidateId(rs.getInt("candidate_id"));
        candidate.setElectionId(rs.getInt("election_id"));
        candidate.setName(rs.getString("name"));
        candidate.setDescription(rs.getString("description"));
        return candidate;
    }
    
    /**
     * Helper method to close JDBC resources
     */
    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) DBUtil.closeConnection(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 
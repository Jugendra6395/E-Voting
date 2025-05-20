package com.election.dao;

import com.election.model.Election;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Election entities
 */
public class ElectionDAO {
    
    /**
     * Creates a new election
     * @param election the Election object to create
     * @return true if successful, false otherwise
     */
    public boolean createElection(Election election) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO elections (title, description, start_date, end_date, created_by) " +
                        "VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, election.getTitle());
            stmt.setString(2, election.getDescription());
            stmt.setTimestamp(3, new Timestamp(election.getStartDate().getTime()));
            stmt.setTimestamp(4, new Timestamp(election.getEndDate().getTime()));
            stmt.setInt(5, election.getCreatedBy());
            
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
     * Gets an election by ID
     * @param electionId the election ID
     * @return Election object if found, null otherwise
     */
    public Election getElectionById(int electionId) {
        Election election = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM elections WHERE election_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, electionId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                election = extractElectionFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return election;
    }
    
    /**
     * Gets all active elections
     * @return List of active elections
     */
    public List<Election> getActiveElections() {
        List<Election> elections = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM elections WHERE is_active = true";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                elections.add(extractElectionFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return elections;
    }
    
    /**
     * Gets all elections
     * @return List of all elections
     */
    public List<Election> getAllElections() {
        List<Election> elections = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM elections";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                elections.add(extractElectionFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return elections;
    }
    
    /**
     * Updates an election
     * @param election the Election object to update
     * @return true if successful, false otherwise
     */
    public boolean updateElection(Election election) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE elections SET title = ?, description = ?, start_date = ?, " +
                        "end_date = ?, is_active = ? WHERE election_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, election.getTitle());
            stmt.setString(2, election.getDescription());
            stmt.setTimestamp(3, new Timestamp(election.getStartDate().getTime()));
            stmt.setTimestamp(4, new Timestamp(election.getEndDate().getTime()));
            stmt.setBoolean(5, election.isActive());
            stmt.setInt(6, election.getElectionId());
            
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
     * Deletes an election
     * @param electionId the election ID to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteElection(int electionId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBUtil.getConnection();
            // Start transaction
            conn.setAutoCommit(false);
            
            // First delete associated votes
            String deleteVotesSql = "DELETE FROM votes WHERE election_id = ?";
            stmt = conn.prepareStatement(deleteVotesSql);
            stmt.setInt(1, electionId);
            stmt.executeUpdate();
            stmt.close();
            
            // Then delete associated candidates
            String deleteCandidatesSql = "DELETE FROM candidates WHERE election_id = ?";
            stmt = conn.prepareStatement(deleteCandidatesSql);
            stmt.setInt(1, electionId);
            stmt.executeUpdate();
            stmt.close();
            
            // Finally delete the election
            String deleteElectionSql = "DELETE FROM elections WHERE election_id = ?";
            stmt = conn.prepareStatement(deleteElectionSql);
            stmt.setInt(1, electionId);
            int rowsAffected = stmt.executeUpdate();
            
            success = (rowsAffected > 0);
            
            // Commit transaction
            conn.commit();
        } catch (SQLException e) {
            // Rollback transaction if error occurs
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(conn, stmt, null);
        }
        
        return success;
    }
    
    /**
     * Checks if an election has associated votes or candidates
     * @param electionId the election ID to check
     * @return a string describing what's associated, or null if nothing is associated
     */
    public String getElectionDependencies(int electionId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String dependencies = null;
        
        try {
            conn = DBUtil.getConnection();
            
            // Check for votes
            String votesSQL = "SELECT COUNT(*) FROM votes WHERE election_id = ?";
            stmt = conn.prepareStatement(votesSQL);
            stmt.setInt(1, electionId);
            rs = stmt.executeQuery();
            
            int voteCount = 0;
            if (rs.next()) {
                voteCount = rs.getInt(1);
            }
            
            rs.close();
            stmt.close();
            
            // Check for candidates
            String candidatesSQL = "SELECT COUNT(*) FROM candidates WHERE election_id = ?";
            stmt = conn.prepareStatement(candidatesSQL);
            stmt.setInt(1, electionId);
            rs = stmt.executeQuery();
            
            int candidateCount = 0;
            if (rs.next()) {
                candidateCount = rs.getInt(1);
            }
            
            // Build dependency message if needed
            if (voteCount > 0 && candidateCount > 0) {
                dependencies = "The election has " + voteCount + " votes and " + candidateCount + " candidates associated with it.";
            } else if (voteCount > 0) {
                dependencies = "The election has " + voteCount + " votes associated with it.";
            } else if (candidateCount > 0) {
                dependencies = "The election has " + candidateCount + " candidates associated with it.";
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return dependencies;
    }
    
    /**
     * Helper method to extract Election object from ResultSet
     */
    private Election extractElectionFromResultSet(ResultSet rs) throws SQLException {
        Election election = new Election();
        election.setElectionId(rs.getInt("election_id"));
        election.setTitle(rs.getString("title"));
        election.setDescription(rs.getString("description"));
        election.setStartDate(rs.getTimestamp("start_date"));
        election.setEndDate(rs.getTimestamp("end_date"));
        election.setCreatedBy(rs.getInt("created_by"));
        election.setCreationDate(rs.getTimestamp("creation_date"));
        election.setActive(rs.getBoolean("is_active"));
        return election;
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
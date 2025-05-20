package com.election.controller;

import com.election.dao.CandidateDAO;
import com.election.dao.ElectionDAO;
import com.election.dao.UserDAO;
import com.election.dao.VoteDAO;
import com.election.model.Candidate;
import com.election.model.Election;
import com.election.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Servlet for handling administrative functions
 */
@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ElectionDAO electionDAO;
    private CandidateDAO candidateDAO;
    private UserDAO userDAO;
    private VoteDAO voteDAO;
    
    @Override
    public void init() {
        electionDAO = new ElectionDAO();
        candidateDAO = new CandidateDAO();
        userDAO = new UserDAO();
        voteDAO = new VoteDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            // Show admin dashboard
            showDashboard(request, response);
        } else if (pathInfo.equals("/create-election")) {
            // Show create election form
            request.getRequestDispatcher("/WEB-INF/views/admin/createElection.jsp").forward(request, response);
        } else if (pathInfo.equals("/manage-elections")) {
            // Show manage elections page
            manageElections(request, response);
        } else if (pathInfo.equals("/manage-users")) {
            // Show manage users page
            manageUsers(request, response);
        } else if (pathInfo.equals("/add-candidate")) {
            // Show add candidate form
            showAddCandidateForm(request, response);
        } else if (pathInfo.equals("/view-results")) {
            // Show election results
            viewResults(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        if (pathInfo.equals("/add-candidate")) {
            // Add a new candidate
            addCandidate(request, response);
        } else if (pathInfo.equals("/update-election")) {
            // Update an election
            updateElection(request, response);
        } else if (pathInfo.equals("/update-user")) {
            // Update a user
            updateUser(request, response);
        } else if (pathInfo.equals("/delete-election")) {
            // Delete an election
            deleteElection(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get count of active elections
        List<Election> activeElections = electionDAO.getActiveElections();
        int activeElectionCount = activeElections.size();
        
        // Get count of all elections
        List<Election> allElections = electionDAO.getAllElections();
        int totalElectionCount = allElections.size();
        
        // Get count of users
        List<User> users = userDAO.getAllUsers();
        int userCount = users.size();
        
        request.setAttribute("activeElectionCount", activeElectionCount);
        request.setAttribute("totalElectionCount", totalElectionCount);
        request.setAttribute("userCount", userCount);
        request.setAttribute("activeElections", activeElections);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
    
    private void manageElections(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Election> elections = electionDAO.getAllElections();
        request.setAttribute("elections", elections);
        request.getRequestDispatcher("/WEB-INF/views/admin/manageElections.jsp").forward(request, response);
    }
    
    private void manageUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/admin/manageUsers.jsp").forward(request, response);
    }
    
    private void showAddCandidateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String electionIdStr = request.getParameter("electionId");
        if (electionIdStr == null || electionIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
            return;
        }
        
        try {
            int electionId = Integer.parseInt(electionIdStr);
            Election election = electionDAO.getElectionById(electionId);
            
            if (election == null) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
                return;
            }
            
            request.setAttribute("election", election);
            request.getRequestDispatcher("/WEB-INF/views/admin/addCandidate.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
        }
    }
    
    private void addCandidate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String electionIdStr = request.getParameter("electionId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        if (electionIdStr == null || electionIdStr.trim().isEmpty() ||
            name == null || name.trim().isEmpty() ||
            description == null || description.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("/WEB-INF/views/admin/addCandidate.jsp").forward(request, response);
            return;
        }
        
        try {
            int electionId = Integer.parseInt(electionIdStr);
            
            // Verify election exists
            Election election = electionDAO.getElectionById(electionId);
            
            if (election == null) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
                return;
            }
            
            // Create candidate object
            Candidate candidate = new Candidate();
            candidate.setElectionId(electionId);
            candidate.setName(name);
            candidate.setDescription(description);
            
            // Save to database
            boolean success = candidateDAO.addCandidate(candidate);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
            } else {
                request.setAttribute("errorMessage", "Failed to add candidate");
                request.setAttribute("election", election);
                request.getRequestDispatcher("/WEB-INF/views/admin/addCandidate.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
        }
    }
    
    private void updateElection(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String electionIdStr = request.getParameter("electionId");
        String isActiveStr = request.getParameter("isActive");
        
        if (electionIdStr == null || electionIdStr.trim().isEmpty() ||
            isActiveStr == null || isActiveStr.trim().isEmpty()) {
            
            response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
            return;
        }
        
        try {
            int electionId = Integer.parseInt(electionIdStr);
            boolean isActive = Boolean.parseBoolean(isActiveStr);
            
            // Get the election
            Election election = electionDAO.getElectionById(electionId);
            
            if (election == null) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
                return;
            }
            
            // Update active status
            election.setActive(isActive);
            
            // Save to database
            boolean success = electionDAO.updateElection(election);
            
            response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
        }
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String isActiveStr = request.getParameter("isActive");
        
        if (userIdStr == null || userIdStr.trim().isEmpty() ||
            isActiveStr == null || isActiveStr.trim().isEmpty()) {
            
            response.sendRedirect(request.getContextPath() + "/admin/manage-users");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            boolean isActive = Boolean.parseBoolean(isActiveStr);
            
            // Get the user
            User targetUser = userDAO.getUserById(userId);
            
            if (targetUser == null) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-users");
                return;
            }
            
            // Update active status
            targetUser.setActive(isActive);
            
            // Save to database
            boolean success = userDAO.updateUser(targetUser);
            
            response.sendRedirect(request.getContextPath() + "/admin/manage-users");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-users");
        }
    }
    
    private void deleteElection(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String electionIdStr = request.getParameter("electionId");
        
        if (electionIdStr == null || electionIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
            return;
        }
        
        try {
            int electionId = Integer.parseInt(electionIdStr);
            
            // First check if the election exists
            Election election = electionDAO.getElectionById(electionId);
            if (election == null) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
                return;
            }
            
            // Check for dependencies and provide detailed message if found
            String dependencies = electionDAO.getElectionDependencies(electionId);
            
            // Delete the election
            boolean success = electionDAO.deleteElection(electionId);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Election deleted successfully");
            } else {
                if (dependencies != null) {
                    request.getSession().setAttribute("errorMessage", "Failed to delete election. " + dependencies + " Please try again later.");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to delete election. Please try again later.");
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
        }
    }
    
    private void viewResults(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String electionIdStr = request.getParameter("id");
        if (electionIdStr == null || electionIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
            return;
        }
        
        try {
            int electionId = Integer.parseInt(electionIdStr);
            Election election = electionDAO.getElectionById(electionId);
            
            if (election == null) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
                return;
            }
            
            // Get results
            List<Candidate> candidates = candidateDAO.getCandidatesByElection(electionId);
            Map<Integer, Integer> voteCounts = voteDAO.getVoteCountByCandidate(electionId);
            int totalVotes = voteDAO.getTotalVoteCount(electionId);
            
            request.setAttribute("election", election);
            request.setAttribute("candidates", candidates);
            request.setAttribute("voteCounts", voteCounts);
            request.setAttribute("totalVotes", totalVotes);
            request.getRequestDispatcher("/WEB-INF/views/admin/viewResults.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-elections");
        }
    }
} 
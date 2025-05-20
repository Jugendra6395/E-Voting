package com.election.controller;

import com.election.dao.CandidateDAO;
import com.election.dao.ElectionDAO;
import com.election.dao.VoteDAO;
import com.election.model.Candidate;
import com.election.model.Election;
import com.election.model.User;
import com.election.model.Vote;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Servlet for handling election operations
 */
@WebServlet("/election/*")
public class ElectionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ElectionDAO electionDAO;
    private CandidateDAO candidateDAO;
    private VoteDAO voteDAO;
    
    @Override
    public void init() {
        electionDAO = new ElectionDAO();
        candidateDAO = new CandidateDAO();
        voteDAO = new VoteDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Show list of active elections
            listElections(request, response);
        } else if (pathInfo.equals("/details")) {
            // Show election details
            showElectionDetails(request, response);
        } else if (pathInfo.equals("/vote")) {
            // Show voting page
            showVotingPage(request, response);
        } else if (pathInfo.equals("/results")) {
            // Show election results
            showElectionResults(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (pathInfo.equals("/create")) {
            // Create a new election
            createElection(request, response);
        } else if (pathInfo.equals("/vote")) {
            // Cast a vote
            castVote(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void listElections(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Election> activeElections = electionDAO.getActiveElections();
        request.setAttribute("elections", activeElections);
        request.getRequestDispatcher("/WEB-INF/views/election/list.jsp").forward(request, response);
    }
    
    private void showElectionDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String electionIdStr = request.getParameter("id");
        if (electionIdStr == null || electionIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/election");
            return;
        }
        
        try {
            int electionId = Integer.parseInt(electionIdStr);
            Election election = electionDAO.getElectionById(electionId);
            
            if (election == null) {
                response.sendRedirect(request.getContextPath() + "/election");
                return;
            }
            
            List<Candidate> candidates = candidateDAO.getCandidatesByElection(electionId);
            
            request.setAttribute("election", election);
            request.setAttribute("candidates", candidates);
            request.getRequestDispatcher("/WEB-INF/views/election/details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/election");
        }
    }
    
    private void showVotingPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String electionIdStr = request.getParameter("id");
        if (electionIdStr == null || electionIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/election");
            return;
        }
        
        try {
            int electionId = Integer.parseInt(electionIdStr);
            Election election = electionDAO.getElectionById(electionId);
            
            if (election == null) {
                response.sendRedirect(request.getContextPath() + "/election");
                return;
            }
            
            // Check if election is active
            Date now = new Date();
            if (now.before(election.getStartDate()) || now.after(election.getEndDate())) {
                request.setAttribute("errorMessage", "This election is not currently active for voting.");
                request.getRequestDispatcher("/WEB-INF/views/election/details.jsp").forward(request, response);
                return;
            }
            
            // Check if user has already voted
            User user = (User) request.getSession().getAttribute("user");
            boolean hasVoted = voteDAO.hasVoted(electionId, user.getUserId());
            
            if (hasVoted) {
                request.setAttribute("errorMessage", "You have already voted in this election.");
                request.getRequestDispatcher("/WEB-INF/views/election/details.jsp").forward(request, response);
                return;
            }
            
            List<Candidate> candidates = candidateDAO.getCandidatesByElection(electionId);
            
            request.setAttribute("election", election);
            request.setAttribute("candidates", candidates);
            request.getRequestDispatcher("/WEB-INF/views/election/vote.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/election");
        }
    }
    
    private void castVote(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String electionIdStr = request.getParameter("electionId");
        String candidateIdStr = request.getParameter("candidateId");
        
        if (electionIdStr == null || electionIdStr.trim().isEmpty() || 
            candidateIdStr == null || candidateIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/election");
            return;
        }
        
        try {
            int electionId = Integer.parseInt(electionIdStr);
            int candidateId = Integer.parseInt(candidateIdStr);
            
            // Verify election and candidate exist
            Election election = electionDAO.getElectionById(electionId);
            Candidate candidate = candidateDAO.getCandidateById(candidateId);
            
            if (election == null || candidate == null || candidate.getElectionId() != electionId) {
                response.sendRedirect(request.getContextPath() + "/election");
                return;
            }
            
            // Check if election is active
            Date now = new Date();
            if (now.before(election.getStartDate()) || now.after(election.getEndDate())) {
                request.setAttribute("errorMessage", "This election is not currently active for voting.");
                request.getRequestDispatcher("/WEB-INF/views/election/details.jsp").forward(request, response);
                return;
            }
            
            // Check if user has already voted
            User user = (User) request.getSession().getAttribute("user");
            boolean hasVoted = voteDAO.hasVoted(electionId, user.getUserId());
            
            if (hasVoted) {
                request.setAttribute("errorMessage", "You have already voted in this election.");
                request.getRequestDispatcher("/WEB-INF/views/election/details.jsp").forward(request, response);
                return;
            }
            
            // Cast the vote
            Vote vote = new Vote();
            vote.setElectionId(electionId);
            vote.setVoterId(user.getUserId());
            vote.setCandidateId(candidateId);
            
            boolean success = voteDAO.castVote(vote);
            
            if (success) {
                request.setAttribute("successMessage", "Your vote has been cast successfully!");
                request.setAttribute("election", election);
                request.getRequestDispatcher("/WEB-INF/views/election/voteSuccess.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to cast your vote. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/election/vote.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/election");
        }
    }
    
    private void showElectionResults(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String electionIdStr = request.getParameter("id");
        if (electionIdStr == null || electionIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/election");
            return;
        }
        
        try {
            int electionId = Integer.parseInt(electionIdStr);
            Election election = electionDAO.getElectionById(electionId);
            
            if (election == null) {
                response.sendRedirect(request.getContextPath() + "/election");
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
            request.getRequestDispatcher("/WEB-INF/views/election/results.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/election");
        }
    }
    
    private void createElection(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Only admin can create elections
        User user = (User) request.getSession().getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/election");
            return;
        }
        
        // Get form parameters
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        // Validate input
        if (title == null || title.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            startDateStr == null || startDateStr.trim().isEmpty() ||
            endDateStr == null || endDateStr.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("/WEB-INF/views/admin/createElection.jsp").forward(request, response);
            return;
        }
        
        try {
            // Parse dates
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date startDate = dateFormat.parse(startDateStr);
            Date endDate = dateFormat.parse(endDateStr);
            
            // Validate dates
            if (startDate.after(endDate)) {
                request.setAttribute("errorMessage", "Start date must be before end date");
                request.getRequestDispatcher("/WEB-INF/views/admin/createElection.jsp").forward(request, response);
                return;
            }
            
            // Create election object
            Election election = new Election();
            election.setTitle(title);
            election.setDescription(description);
            election.setStartDate(startDate);
            election.setEndDate(endDate);
            election.setCreatedBy(user.getUserId());
            election.setActive(true);
            
            // Save to database
            boolean success = electionDAO.createElection(election);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                request.setAttribute("errorMessage", "Failed to create election");
                request.getRequestDispatcher("/WEB-INF/views/admin/createElection.jsp").forward(request, response);
            }
            
        } catch (ParseException e) {
            request.setAttribute("errorMessage", "Invalid date format");
            request.getRequestDispatcher("/WEB-INF/views/admin/createElection.jsp").forward(request, response);
        }
    }
} 
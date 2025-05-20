package com.election.controller;

import com.election.dao.ElectionDAO;
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

/**
 * Servlet for handling the home page
 */
@WebServlet({"/home", "/"})
public class HomeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ElectionDAO electionDAO;
    
    @Override
    public void init() {
        electionDAO = new ElectionDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            // User is not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        // If user is admin, redirect to admin dashboard
        if ("admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        
        // Get active elections for regular users
        List<Election> activeElections = electionDAO.getActiveElections();
        request.setAttribute("activeElections", activeElections);
        
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
} 
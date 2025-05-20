# E-Voting System

A secure and user-friendly web-based application designed to facilitate electronic voting for various types of elections.

## Overview

The E-Voting System modernizes the traditional voting process by leveraging technology to:
- Reduce costs and logistics associated with physical voting
- Increase voter participation through remote access
- Provide immediate and accurate tabulation of results
- Ensure security and transparency in the electoral process

## Features

### User Authentication and Management
- Secure login and registration
- Role-based access control (admin and voter roles)
- User account activation/deactivation by administrators

### Election Management
- Create and configure elections with title, description, and date ranges
- Add candidates to elections
- Activate/deactivate elections
- View comprehensive election details

### Voting Process
- User-friendly interface for casting votes
- One vote per voter per election enforcement
- Real-time verification of election status
- Vote confirmation and receipt

### Results and Analysis
- Tabulation of votes by candidate
- Percentage calculation for each candidate
- Visual representation of results
- Export results functionality (CSV and PDF formats)

## Technology Stack

- **Frontend**: HTML5, CSS3, Bootstrap, JSP
- **Backend**: Java, Servlets
- **Database**: MySQL
- **Web Container**: Apache Tomcat
- **Build Tool**: Maven
- **Connection**: JDBC

## Installation Guide

### Prerequisites
- Java Development Kit (JDK) 11 or higher
- MySQL 8.0 or higher
- Apache Tomcat 9.0 or higher
- Maven 3.6 or higher

### Database Setup
1. Create a MySQL database named `evoting`
2. Configure the database connection in `DBUtil.java` with appropriate credentials
3. Navigate to `http://localhost:8080/e-voting/manualSetup.jsp` to initialize the database

### Application Deployment
1. Clone this repository:
   ```
   git clone https://github.com/yourusername/e-voting.git
   ```
2. Build the project using Maven:
   ```
   mvn clean package
   ```
3. Deploy the generated WAR file to Tomcat
4. Access the application at `http://localhost:8080/e-voting`
5. Default admin credentials: 
   - Username: `admin`
   - Password: `admin123`

## System Architecture

The application follows the Model-View-Controller (MVC) architectural pattern:
- **Model**: Java classes representing business entities (User, Election, Candidate, Vote)
- **View**: JSP pages for presenting data to users and handling user interaction
- **Controller**: Servlet classes that process user requests and manipulate the model

## Security Considerations

- Session management for authenticated users
- Role-based access control
- Parameterized queries to prevent SQL injection
- Server-side validation of all form inputs
- One vote per voter enforcement

## Future Enhancements

- Two-factor authentication
- Mobile application
- Blockchain-based vote verification
- Advanced analytics for voting patterns
- Support for complex voting methods

## License

[Add your license information here]

## Contributors

[Add contributor information here] 

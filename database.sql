-- Create the database
CREATE DATABASE IF NOT EXISTS evoting;
USE evoting;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'voter',
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Create elections table
CREATE TABLE IF NOT EXISTS elections (
    election_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    created_by INT,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Create candidates table
CREATE TABLE IF NOT EXISTS candidates (
    candidate_id INT AUTO_INCREMENT PRIMARY KEY,
    election_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    FOREIGN KEY (election_id) REFERENCES elections(election_id)
);

-- Create votes table
CREATE TABLE IF NOT EXISTS votes (
    vote_id INT AUTO_INCREMENT PRIMARY KEY,
    election_id INT NOT NULL,
    voter_id INT NOT NULL,
    candidate_id INT NOT NULL,
    vote_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (election_id) REFERENCES elections(election_id),
    FOREIGN KEY (voter_id) REFERENCES users(user_id),
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id),
    UNIQUE KEY (election_id, voter_id) -- Ensure one vote per user per election
);

-- Insert admin user (password: admin123)
INSERT INTO users (username, password, email, full_name, role)
VALUES ('admin', 'admin123', 'admin@example.com', 'System Administrator', 'admin');

-- Create a sample election
INSERT INTO elections (title, description, start_date, end_date, created_by)
VALUES ('Student Council Election 2025', 'Annual student council election for the academic year 2025-2026', 
        '2025-05-01 08:00:00', '2025-05-10 20:00:00', 1);

-- Create sample candidates
INSERT INTO candidates (election_id, name, description)
VALUES (1, 'John Smith', 'Junior, Computer Science major'),
       (1, 'Maria Garcia', 'Senior, Political Science major'),
       (1, 'David Johnson', 'Sophomore, Business Administration major'); 
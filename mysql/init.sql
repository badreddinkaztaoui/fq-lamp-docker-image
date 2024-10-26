CREATE DATABASE IF NOT EXISTS lampdb;
USE lampdb;

-- Create user and grant privileges
CREATE USER IF NOT EXISTS 'ghost'@'%' IDENTIFIED BY '1337';
GRANT ALL PRIVILEGES ON myapp.* TO 'ghost'@'%';
FLUSH PRIVILEGES;

-- Add your table definitions here
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, email) VALUES
    ('test_user', 'test@example.com');

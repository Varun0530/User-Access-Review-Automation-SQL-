create database xyz;
use xyz;
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UserName VARCHAR(100) NOT NULL,
    Department VARCHAR(100) NOT NULL,
    LastLogin DATETIME
);

CREATE TABLE Roles (
    RoleID INT AUTO_INCREMENT PRIMARY KEY,
    RoleName VARCHAR(100) NOT NULL
);

CREATE TABLE UserRoles (
    UserRoleID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    RoleID INT NOT NULL,
    AssignedBy VARCHAR(100),
    AssignedOn DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

CREATE TABLE Projects (
    ProjectID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    Department VARCHAR(100) NOT NULL
);

INSERT INTO Users (UserName, Department, LastLogin) VALUES
('Alice', 'HR', '2024-10-15'),
('Bob', 'Finance', '2024-07-10'),
('Charlie', 'IT', '2024-09-25'),
('Daisy', 'HR', '2024-08-01'),
('Eve', 'IT', '2024-11-01');

INSERT INTO Roles (RoleName) VALUES
('Admin'),
('Manager'),
('Analyst'),
('Engineer');

INSERT INTO UserRoles (UserID, RoleID, AssignedBy) VALUES
(1, 2, 'System'),
(2, 3, 'System'),
(3, 1, 'System'),
(4, 2, 'Admin'),
(5, 4, 'Admin');


INSERT INTO Projects (ProjectName, Department) VALUES
('Recruitment', 'HR'),
('Budget Analysis', 'Finance'),
('Network Upgrade', 'IT');
SELECT 
    U.Department,
    R.RoleName,
    COUNT(U.UserID) AS ActiveUserCount
FROM 
    Users U
JOIN 
    UserRoles UR ON U.UserID = UR.UserID
JOIN 
    Roles R ON UR.RoleID = R.RoleID
WHERE 
    U.LastLogin >= DATE_SUB(NOW(), INTERVAL 90 DAY) 
GROUP BY 
    U.Department, R.RoleName
ORDER BY 
    U.Department, R.RoleName;
SELECT 
    UserID, UserName, Department, LastLogin
FROM 
    Users
WHERE 
    LastLogin < DATE_SUB(NOW(), INTERVAL 90 DAY);
SELECT 
    U.UserID, 
    U.UserName, 
    U.Department, 
    R.RoleName, 
    P.ProjectName
FROM 
    Users U
JOIN 
    UserRoles UR ON U.UserID = UR.UserID
JOIN 
    Roles R ON UR.RoleID = R.RoleID
LEFT JOIN 
    Projects P ON U.Department = P.Department
WHERE 
    U.Department NOT IN (
        SELECT DISTINCT Department
        FROM Projects
    );

SET GLOBAL event_scheduler = ON;
DELIMITER $$

CREATE EVENT GenerateUserAccessReport
ON SCHEDULE EVERY 1 MONTH STARTS CURRENT_TIMESTAMP
DO
BEGIN
   
    SELECT 
        U.Department, 
        R.RoleName, 
        COUNT(U.UserID) AS ActiveUserCount
    INTO OUTFILE '/var/lib/mysql-files/active_user_report.csv'
    FIELDS TERMINATED BY ',' ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    FROM 
        Users U
    JOIN 
        UserRoles UR ON U.UserID = UR.UserID
    JOIN 
        Roles R ON UR.RoleID = R.RoleID
    WHERE 
        U.LastLogin >= DATE_SUB(NOW(), INTERVAL 90 DAY)
    GROUP BY 
        U.Department, R.RoleName;

  
    SELECT 
        UserID, UserName, Department, LastLogin
    INTO OUTFILE '/var/lib/mysql-files/inactive_user_report.csv'
    FIELDS TERMINATED BY ',' ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    FROM 
        Users
    WHERE 
        LastLogin < DATE_SUB(NOW(), INTERVAL 90 DAY);
END$$

DELIMITER ;




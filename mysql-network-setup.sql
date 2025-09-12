-- MySQL Network Access Setup
-- Creates dedicated 'remote' user for database operations
-- This avoids root user issues and provides proper access control

-- Run with mysqlsh --sql -u root -p[PASSWORD] < mysql-network-setup.sql

-- Create remote user for local and network access
CREATE USER IF NOT EXISTS 'remote'@'localhost' IDENTIFIED BY 'Remote2025!';
CREATE USER IF NOT EXISTS 'remote'@'127.0.0.1' IDENTIFIED BY 'Remote2025!';
CREATE USER IF NOT EXISTS 'remote'@'192.168.1.%' IDENTIFIED BY 'Remote2025!';

-- Grant all privileges on chears databases
GRANT ALL PRIVILEGES ON `chears`.* TO 'remote'@'localhost';
GRANT ALL PRIVILEGES ON `chears-*`.* TO 'remote'@'localhost';
GRANT ALL PRIVILEGES ON `chears`.* TO 'remote'@'127.0.0.1';
GRANT ALL PRIVILEGES ON `chears-*`.* TO 'remote'@'127.0.0.1';
GRANT ALL PRIVILEGES ON `chears`.* TO 'remote'@'192.168.1.%';
GRANT ALL PRIVILEGES ON `chears-*`.* TO 'remote'@'192.168.1.%';

-- Grant schema creation privileges
GRANT CREATE ON *.* TO 'remote'@'localhost';
GRANT CREATE ON *.* TO 'remote'@'127.0.0.1';
GRANT CREATE ON *.* TO 'remote'@'192.168.1.%';

-- Apply changes
FLUSH PRIVILEGES;

-- Show created users
SELECT User, Host FROM mysql.user WHERE User = 'remote';

-- To run this file:
-- mysql -u root -p < mysql-network-setup.sql

-- CONNECTION TESTING COMMANDS
-- Run these commands separately to test the remote user connections

-- Test 1: Test localhost connection
-- mysqlsh --sql -u remote -p -h localhost -e "SELECT 'localhost connection successful' as test_result;"

-- Test 2: Test 127.0.0.1 connection  
-- mysqlsh --sql -u remote -p -h 127.0.0.1 -e "SELECT '127.0.0.1 connection successful' as test_result;"

-- Test 3: Test network connection (replace YOUR_SERVER_IP with actual server IP)
-- mysqlsh --sql -u remote -p -h YOUR_SERVER_IP -e "SELECT 'network connection successful' as test_result;"

-- Test 4: Check if MySQL is listening on all interfaces
-- netstat -an | grep 3306

-- Test 5: Test port connectivity from remote machine
-- telnet YOUR_SERVER_IP 3306

-- Test 6: Show MySQL bind-address configuration
-- mysqlsh --sql -u root -p -e "SHOW VARIABLES LIKE 'bind_address';"

-- Test 7: Show all remote users created
-- mysqlsh --sql -u root -p -e "SELECT User, Host, plugin FROM mysql.user WHERE User = 'remote';"

-- TROUBLESHOOTING NOTES:
-- If network connections fail, check:
-- 1. MySQL bind-address setting (should be 0.0.0.0 or commented out)
-- 2. Firewall rules allowing port 3306
-- 3. Network device IP is in 192.168.1.x range
-- 4. MySQL service is running and listening on port 3306
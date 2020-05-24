SET @drop_database = CONCAT('DROP DATABASE IF EXISTS ', @dbname);
SELECT 'RUNNING THE FOLLOWING query : ' , @drop_database;
PREPARE stmt FROM @drop_database;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @create_database = CONCAT('CREATE DATABASE ', @dbname);
SELECT 'RUNNING THE FOLLOWING query : ' , @create_database;
PREPARE stmt FROM @create_database;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

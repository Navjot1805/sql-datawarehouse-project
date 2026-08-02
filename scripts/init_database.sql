/* 
=====================================================
Create Database and Schemas
=====================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists.
    If the database is exists, it is dropped and recreated. Additionally, the script sets up three schemas
    within the database: 'bronze','silver' and 'gold'.

WARNING:
    Running this script will drop the entire 'DataWarehouse' Database if it exists.
    ALl data in the database will be permanently deleted.Proceed with caution and ensure you have proper backups before running this script.
    */

-- I already created the database named datawarehouse
-- CREATE DATABASE DataWarehouse
USE DataWarehouse;

-- Create Schemas
CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Silver;
Go

CREATE SCHEMA Gold;
Go

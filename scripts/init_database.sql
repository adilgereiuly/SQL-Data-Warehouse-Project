/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'datawarehouse' after dropping
    it if it already exists. It also sets up three schemas within the
    database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'datawarehouse' database if it
    exists. All data in the database will be permanently deleted. Proceed
    with caution and ensure you have proper backups before running this script.

NOTE (PostgreSQL):
    Unlike SQL Server, PostgreSQL does not allow creating a database and then
    creating schemas inside it within the same connection/script. Run the
    database creation step while connected to 'postgres', then reconnect to
    'datawarehouse' before running the schema creation step.
*/


-- Step 1: run while connected to 'postgres'
DROP DATABASE IF EXISTS datawarehouse;
CREATE DATABASE datawarehouse;

-- Step 2: run while connected to 'datawarehouse'
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

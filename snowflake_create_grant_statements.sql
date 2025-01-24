


USE ROLE ACCOUNTADMIN;
-- Role that will be used to create services
CREATE ROLE IF NOT EXISTS demo_role;

-- Creating database if its not exist already
CREATE DATABASE IF NOT EXISTS MATE_DB;

-- Grant ownership on the DB to cheatsheets_spcs_demo_role
GRANT OWNERSHIP ON DATABASE MATE_DB TO ROLE demo_role COPY CURRENT GRANTS;

-- use cheatsheets_spcs_demo_role to create the data schema
USE ROLE demo_role;

-- data_schema will house the image repositories
CREATE SCHEMA IF NOT EXISTS MATE_DB.DATA_SCHEMA;

-- Switch back to accountadmin for rest of the tasks
USE ROLE ACCOUNTADMIN;

-- Create warehouse to be used for queries from the service
CREATE WAREHOUSE IF NOT EXISTS demo_wh_s WITH
  WAREHOUSE_SIZE='X-SMALL'
  -- disable auto start
  INITIALLY_SUSPENDED=TRUE
  -- auto suspend in two mins
  AUTO_SUSPEND=120;

-- grants on warehouse to cheatsheets_spcs_demo_role
GRANT USAGE ON WAREHOUSE demo_wh_s TO ROLE demo_role;

-- allow endpoint binding to role 
GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO ROLE demo_role;

-- allow role to use and monitor compute pool
GRANT USAGE, MONITOR ON COMPUTE POOL my_xs_compute_pool TO ROLE demo_role;

-- grant cheatsheets_spcs_demo_role role to current user
GRANT ROLE demo_role TO USER &{ctx.env.SNOWFLAKE_USER};
-- FlashFusion SoT - PostgreSQL Initialization Script
-- Runs automatically when database is first created

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Create schemas (optional - uncomment if needed)
-- CREATE SCHEMA IF NOT EXISTS flashfusion;
-- CREATE SCHEMA IF NOT EXISTS harvestflow;
-- CREATE SCHEMA IF NOT EXISTS triage;

-- Log initialization
DO $$
BEGIN
  RAISE NOTICE 'FlashFusion SoT database initialized successfully';
END $$;

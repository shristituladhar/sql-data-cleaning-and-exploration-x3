 -- STEP 1: Setup (Creating the database and using it)
 CREATE DATABASE IMDBProject;
 GO

 USE IMDBProject;
 GO

 -- STEP 2: Duplicate the original dataset to keep raw data untouched
 SELECT * INTO imdb_dupe FROM imdb_top_1000;

 -- Preview table and check contents
 SELECT * FROM imdb_dupe;

 -- STEP 3: Drop 'Poster_Link' column; not useful for analysis (just image URLs)
 SELECT TOP 10 Poster_Link FROM imdb_dupe;
 ALTER TABLE imdb_dupe DROP COLUMN Poster_Link;

 -- STEP 4: Clean 'Released_Year'
-- Check for non-numeric entries (e.g., 'PG')
SELECT DISTINCT Released_Year FROM imdb_dupe ORDER BY Released_Year;
SELECT Released_Year FROM imdb_dupe WHERE ISNUMERIC(Released_Year) = 0;

-- Allow NULLs in Released_Year to handle bad data
ALTER TABLE imdb_dupe ALTER COLUMN Released_Year NVARCHAR(50) NULL;

-- Replace invalid entry 'PG' with NULL
UPDATE imdb_dupe SET Released_Year = NULL WHERE Released_Year = 'PG';

-- Convert 'Released_Year' from text to INT
ALTER TABLE imdb_dupe ALTER COLUMN Released_Year INT;

-- STEP 5: Clean and standardize 'Certificate' values
SELECT DISTINCT Certificate FROM imdb_dupe ORDER BY Certificate;

-- Standardize naming and fix outdated values
UPDATE imdb_dupe SET Certificate = 'Approved' WHERE Certificate = 'Passed';
UPDATE imdb_dupe SET Certificate = 'PG' WHERE Certificate = 'GP';
UPDATE imdb_dupe SET Certificate = 'U/A' WHERE Certificate = 'UA';

-- Replace inconsistent or unsupported values with NULL
UPDATE imdb_dupe SET Certificate = NULL WHERE Certificate IN ('16', 'Unrated');

-- STEP 6: Clean 'Runtime' column
-- Inspect values and datatype
SELECT DISTINCT Runtime FROM imdb_dupe ORDER BY Runtime;
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'imdb_dupe' AND COLUMN_NAME = 'Runtime';

-- Add new column to store runtime in integer minutes
ALTER TABLE imdb_dupe ADD Runtime_Minutes INT;

-- Clean and convert runtime string (e.g., '152 min') to integer
UPDATE imdb_dupe
SET Runtime_Minutes = CAST(REPLACE(Runtime, 'min', '') AS INT);

-- Confirm new column is valid before dropping the original
SELECT TOP 10 Runtime, Runtime_Minutes FROM imdb_dupe;

-- Drop original 'Runtime' column after confirmation
ALTER TABLE imdb_dupe DROP COLUMN Runtime;

-- STEP 7: Clean 'IMDB_Rating'
-- Check unique values and precision issues
SELECT DISTINCT IMDB_Rating FROM imdb_dupe ORDER BY IMDB_Rating;
SELECT TABLE_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'imdb_dupe' AND COLUMN_NAME = 'IMDB_Rating';

-- Create a new column to store clean, rounded rating
ALTER TABLE imdb_dupe ADD IMDB_Rating_Rounded DECIMAL(3,1);
UPDATE imdb_dupe SET IMDB_Rating_Rounded = ROUND(IMDB_Rating, 1);

-- STEP 8: Drop 'Overview' column (long text, not used for numeric analysis)
-- First back it up in case we want to use it for NLP or display later
SELECT Series_Title, Overview INTO Overview_Backup FROM imdb_dupe;

-- Drop the bulky text column
ALTER TABLE imdb_dupe DROP COLUMN Overview;

-- STEP 9: Inspect and validate 'Gross' column
SELECT DISTINCT Gross FROM imdb_dupe ORDER BY Gross;
SELECT TABLE_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'imdb_dupe' AND COLUMN_NAME = 'Gross';

-- Preview top values to ensure it's clean and usable
SELECT TOP 30 Gross FROM imdb_dupe ORDER BY Gross DESC;

-- AND, Final Checkup - ready for data exploration
SELECT * FROM imdb_dupe;


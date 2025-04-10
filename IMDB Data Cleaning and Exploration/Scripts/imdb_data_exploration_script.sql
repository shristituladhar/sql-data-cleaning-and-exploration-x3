SELECT * FROM imdb_dupe;


-- 1. Popular and Highest Rated Movies
-- Top 10 highest-rated movies with most number of votes
SELECT TOP 10 Series_Title, IMDB_Rating_Rounded, No_of_Votes
FROM imdb_dupe
ORDER BY IMDB_Rating_Rounded DESC, No_of_Votes DESC;

-- Top 10 Longest movies by runtime and their released year
SELECT TOP 10 Series_Title, Runtime_Minutes, Released_Year
FROM imdb_dupe
ORDER BY Runtime_Minutes DESC;


-- 2. Box Office Earnings
-- Top 5 highest grossing movies with year, director, and rating
SELECT TOP 5 Series_Title, Gross, Released_Year, Director, IMDB_Rating_Rounded
FROM imdb_dupe
WHERE GROSS IS NOT NULL
ORDER BY Gross DESC;

-- Total Gross Earnings by year
SELECT Released_Year, SUM(CAST(Gross AS BIGINT)) AS TotalGross
FROM imdb_dupe
WHERE Gross IS NOT NULL -- AND Released_Year IS NOT NULL
GROUP BY Released_Year
ORDER BY Released_Year;

-- Gross vs Certificate
SELECT Gross, Certificate
FROM imdb_dupe
WHERE Certificate is NOT NULL AND GROSS IS NOT NULL
ORDER BY GROSS DESC;


-- 3. Genre and Content Trends
-- What genres are most popular?
SELECT Genre, COUNT(*) AS MovieCount
FROM imdb_dupe
GROUP BY Genre;

-- How many comedy movies were released before 2000s?
SELECT Genre, Released_Year
FROM imdb_dupe
WHERE Genre LIKE '%Comedy%' AND Released_Year < 2000;

-- Movie Count grouped by both genre and Certificate
SELECT Genre, Certificate, COUNT(*) AS MovieCount
FROM imdb_dupe
WHERE Certificate IS NOT NULL
GROUP BY Genre, Certificate
ORDER BY MovieCount DESC;

-- Specific genre search: Action + Adventure movies sorted by rating
SELECT Genre, IMDB_Rating_Rounded
FROM imdb_dupe
WHERE Genre LIKE '%Action, Adventure%'
ORDER BY IMDB_Rating_Rounded DESC;


-- 4. Different other explorations
-- How many movies per certificate?
SELECT Certificate, COUNT(*) AS MovieCount
FROM imdb_dupe
WHERE Certificate IS NOT NULL
GROUP BY Certificate
ORDER BY MovieCount DESC;

-- In what year did most of the movies released?
SELECT Released_Year, COUNT(*) AS MovieCount
FROM imdb_dupe
WHERE Released_Year > 2000
GROUP BY Released_Year
ORDER BY Moviecount DESC;

-- Comparing Runtime to IMDB Rating (if longer movies has better ratings)
SELECT Series_Title, Runtime_minutes, IMDB_Rating_Rounded
FROM imdb_dupe
WHERE Runtime_Minutes IS NOT NULL AND IMDB_Rating_Rounded IS NOT NULL
ORDER BY Runtime_Minutes DESC;

-- MovieCounts for highest to lowest IMDB Ratings
SELECT IMDB_Rating_Rounded, COUNT(*) AS MovieCount
FROM imdb_dupe
GROUP BY IMDB_Rating_Rounded
ORDER BY IMDB_Rating_Rounded DESC;

-- Popularity of genres using vote counts
SELECT Genre, No_of_Votes
FROM imdb_dupe
ORDER BY No_of_Votes DESC

-- Top 5 most frequent directors in the dataset
SELECT TOP 5 Director, COUNT(*) AS MovieCount
FROM imdb_dupe
GROUP BY Director
ORDER BY MovieCount DESC;
-- We can see that Alfred Hitchcock directed 14 movies coming to first place with Steven Spielberg coming to second place with him
-- being the director for 13 movies.

-- Meta Score with Average IMDB Rating
SELECT Meta_score, ROUND(AVG(IMDB_Rating), 2) AS AverageIMDB
FROM imdb_dupe
WHERE Meta_score IS NOT NULL
GROUP BY Meta_score
ORDER BY Meta_score DESC;

-- Classify movies into rating categories using CASE (e.g., 'Masterpiece', 'Excellent', etc.)
SELECT Series_Title, IMDB_Rating_Rounded,
CASE 
	WHEN IMDB_Rating_Rounded >= 9 THEN 'Masterpiece'
	WHEN IMDB_Rating_Rounded >= 8 THEN 'Excellent'
	WHEN IMDB_Rating_Rounded >= 7 THEN 'Good'
	ELSE 'Average'
END AS Rating_Category
FROM imdb_dupe;

-- Use STRING_SPLIT() to break multi-genre values (like 'Action, Drama') into separate rows and count frequency
SELECT value AS Genre, COUNT(*) AS GenreCount
FROM imdb_dupe
CROSS APPLY string_split(Genre, ',')
GROUP BY value
ORDER BY GenreCount DESC;


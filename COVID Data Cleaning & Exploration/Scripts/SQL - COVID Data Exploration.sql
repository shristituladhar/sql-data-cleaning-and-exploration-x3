/* 
SQL Queries for Analyzing COVID-19 Data
Data is sourced from Our World in Data (https://ourworldindata.org/coronavirus),
which aggregates and visualizes COVID-19 data from various reliable sources.

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

-- Query 1: Covid Deaths Data
SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL -- Exclude entries with NULL continent
ORDER BY 3, 4; -- Order by third and fourth columns

-- Query 2: Covid Vaccinations Data
SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3, 4;

-- Query 3: Total Cases and Deaths by Location and Date
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2;

-- Query 4: Total Cases vs Total Deaths for Nepal
SELECT Location, date, total_cases, total_deaths,
    CASE
        WHEN total_cases = 0 THEN NULL
        ELSE (total_deaths / total_cases) * 100
    END AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location LIKE '%Nepal%'
ORDER BY 1, 2;

-- Query 5: Total Cases vs Population
SELECT Location, date, population, total_cases, (total_cases / population) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2;

-- Query 6: Countries with highest Infection Rate 
SELECT Location, population, MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Query 7: Countries with highest death count per population
SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Query 8: Continents with highest death count per location
SELECT continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Query 9: Global COVID-19 Statistics
SELECT
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS int)) AS total_deaths,
    CASE
        WHEN SUM(new_cases) = 0 THEN NULL
        ELSE SUM(CAST(new_deaths AS int)) / SUM(new_cases) * 100
    END AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Query 10: Total Population vs Vaccinations
SELECT
    CD.continent,
    CD.location,
    CD.date,
    CD.population,
    CV.new_vaccinations,
    SUM(CAST(CV.new_vaccinations AS bigint)) OVER
        (PARTITION BY CD.location ORDER BY CD.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths CD
JOIN PortfolioProject..CovidVaccinations CV
    ON CD.location = CV.location AND CD.date = CV.date
WHERE CD.continent IS NOT NULL
ORDER BY 2, 3;

-- Query 11: Use of Common Table Expression (CTE)
;WITH PopvsVac AS (
    SELECT
        CD.continent,
        CD.location,
        CD.date,
        CD.population,
        CV.new_vaccinations,
        SUM(CAST(CV.new_vaccinations AS bigint)) OVER
            (PARTITION BY CD.location ORDER BY CD.date) AS RollingPeopleVaccinated
    FROM PortfolioProject..CovidDeaths CD
    JOIN PortfolioProject..CovidVaccinations CV
        ON CD.location = CV.location AND CD.date = CV.date
    WHERE CD.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated / population) * 100 AS VaccinationPercentage
FROM PopvsVac; -- Calculate Vaccination Percentage

-- Query 12: Temporary Table for Vaccination Data
DROP TABLE IF EXISTS #PercentPopulationVaccinated;
CREATE TABLE #PercentPopulationVaccinated (
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    new_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO #PercentPopulationVaccinated
SELECT
    CD.continent,
    CD.location,
    CD.date,
    CD.population,
    CV.new_vaccinations,
    SUM(CAST(CV.new_vaccinations AS bigint)) OVER
        (PARTITION BY CD.location ORDER BY CD.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths CD
JOIN PortfolioProject..CovidVaccinations CV
    ON CD.location = CV.location AND CD.date = CV.date;

-- Vaccination Percentage from Temp Table
SELECT *, (RollingPeopleVaccinated / population) * 100 AS VaccinationPercentage
FROM #PercentPopulationVaccinated;

-- Query 13: Creating a View for Future Visualization
CREATE VIEW PercentPopulationVaccinated AS
SELECT
    CD.continent,
    CD.location,
    CD.date,
    CD.population,
    CV.new_vaccinations,
    SUM(CAST(CV.new_vaccinations AS bigint)) OVER
        (PARTITION BY CD.location ORDER BY CD.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths CD
JOIN PortfolioProject..CovidVaccinations CV
    ON CD.location = CV.location AND CD.date = CV.date
WHERE CD.continent IS NOT NULL;

-- Retrieve Data from Created View
SELECT *
FROM PercentPopulationVaccinated;

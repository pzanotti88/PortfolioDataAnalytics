-- Table 1 - Global numbers 

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, ROUND((SUM(new_deaths)/SUM(New_Cases)*100),2) as DeathPercentage
FROM covid_db..covid_deaths
WHERE continent IS NOT NULL


--- Table 2 - Continents Numbers

-- Global numbers by continents
SELECT continent, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, ROUND((SUM(new_deaths)/SUM(New_Cases)*100),2) as DeathPercentage
FROM covid_db..covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_cases DESC

-- Table 3 - Infection Rates by Countries

-- Highest Infection Rates compared to population by Countries
SELECT location, population, MAX(total_cases) AS total_cases, ROUND(MAX((total_cases/population)*100),2) as PopulationInfectedPercentage
FROM covid_db..covid_deaths
GROUP BY location, population
ORDER BY PopulationInfectedPercentage DESC

-- Table 4 -
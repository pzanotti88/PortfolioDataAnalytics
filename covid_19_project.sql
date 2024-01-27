
/*
Covid 19 Data Exploration 

Skills used: Joins, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


-- Retrieve all data from the covid_deaths table, ordered by location and date
SELECT *
FROM covid_db..covid_deaths
ORDER BY location, date

-- Retrieve all data from the covid_vaccinations table, ordered by location and date
SELECT *
FROM covid_db..covid_vaccinations
ORDER BY location, date


-- Identify and implement schema changes to optimize performance by altering column data types
-- Total cases column
SELECT *
FROM covid_db..covid_deaths
WHERE TRY_CAST(total_cases AS INT) IS NULL
      AND total_cases IS NOT NULL;

ALTER TABLE covid_db..covid_deaths
ALTER COLUMN total_cases INT;

--Total deaths column
SELECT *
FROM covid_db..covid_deaths
WHERE TRY_CAST(total_deaths AS FLOAT) IS NULL
      AND total_deaths IS NOT NULL;

ALTER TABLE covid_db..covid_deaths
ALTER COLUMN total_deaths FLOAT;


-- Select Data that I am going to be starting with
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM covid_db..covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2


-- Looking into Total Cases vs Total Deaths
-- Show the possibility to die if you get Covid
SELECT location, date, total_cases, total_deaths, ROUND(((total_deaths/total_cases)*100),2) as DeathPercentage
FROM covid_db..covid_deaths
ORDER BY location, date


-- Looking into Total Cases vs Population
-- Show whats percentage of population got the test and it was comfirmed positive of Covid
SELECT location, date,  population, total_cases, ROUND(((total_cases/population)*100),2) as PopulationInfectedPercentage
FROM covid_db..covid_deaths
ORDER BY location, date

-- Highest Infection Rates compared to population
SELECT location, population, MAX(total_cases) AS total_cases, ROUND(MAX((total_cases/population)*100),2) as PopulationInfectedPercentage
FROM covid_db..covid_deaths
GROUP BY location, population
ORDER BY PopulationInfectedPercentage DESC

--Showing countries with Highets Death Count 
SELECT location, population, MAX(total_deaths) AS total_deaths
FROM covid_db..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY total_deaths DESC


--CONTINENTS

--Showing deaths by continent and countries
SELECT continent, location, MAX(total_deaths) AS total_deaths
FROM covid_db..covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent, location
ORDER BY continent, total_deaths DESC

-- Global numbers 
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, ROUND((SUM(new_deaths)/SUM(New_Cases)*100),2) as DeathPercentage
FROM covid_db..covid_deaths
WHERE continent IS NOT NULL


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations
, SUM(CONVERT(FLOAT,vacc.new_vaccinations)) OVER (PARTITION BY deaths.Location ORDER BY deaths.location, deaths.Date) AS RollingPeopleVaccinated
FROM covid_db..covid_deaths deaths
JOIN covid_db..covid_vaccinations vacc
	ON deaths.location = vacc.location
	AND deaths.date = vacc.date
WHERE deaths.continent IS NOT NULL 
ORDER BY deaths.continent, deaths.location, deaths.date


-- Creating a View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations
, SUM(CONVERT(FLOAT,vacc.new_vaccinations)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS RollingPeopleVaccinated
FROM covid_db..covid_deaths deaths
JOIN covid_db..covid_vaccinations vacc
	ON deaths.location = vacc.location
	AND deaths.date = vacc.date
WHERE deaths.continent IS NOT NULL



SELECT * 
FROM PercentPopulationVaccinated



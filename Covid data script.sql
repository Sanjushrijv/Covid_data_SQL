
-- Slide 1- Total cases in year 2020
SELECT MONTH(date), SUM(total_cases) as Total_cases
FROM covid_dataset
WHERE YEAR(date) =2020
GROUP BY MONTH(date)
ORDER BY MONTH(date);

-- Slide 2- Locations with highest case initially (MARCH, 2020)
SELECT location, SUM(total_cases) as Total_cases
FROM covid_dataset
WHERE YEAR(date) =2020 AND MONTH(date) = 3
GROUP BY location
ORDER BY SUM(total_cases) DESC
LIMIT 6, 10;

-- Slide 3- Number of cases distribution in year 2(MARCH, 2021)
SELECT location, SUM(total_cases) as Total_cases
FROM covid_dataset
WHERE YEAR(date) =2021 AND MONTH(date) = 3
GROUP BY location
ORDER BY SUM(total_cases) DESC
LIMIT 10, 10;

-- Slide 4- Country with highest vaccines injected when introduced (JANUARY, 2021)
SELECT location, SUM(people_vaccinated) as ppl_vaccinated
FROM covid_dataset
WHERE YEAR(date) = 2021 AND MONTH(date) = 1 
AND location NOT IN ('Asia', 'World', 'Upper middle income', 'Lower middle income', 'High income', 'Low income', 'Europe', 'North America', 'South America', 'European Union')
GROUP BY location
ORDER BY SUM(people_vaccinated) DESC
LIMIT 10;

-- Slide 5 - Continents with least cases at the mid of 2022(When vaccine drive was started)
SELECT continent, ROUND(SUM(new_cases_per_million),2) as new_cases, SUM(population)
FROM covid_dataset
WHERE YEAR(date) = 2022 AND MONTH (date) = 8
AND continent NOT IN ('World', 'Upper middle income', 'Lower middle income', 'High income', 'Low income','0')
GROUP BY continent
ORDER BY SUM(new_cases_per_million);

-- Slide 6 - Comparing death rate with vaccinated people ratio by 2021 and 2022
SELECT
    continent,
    (SUM(CASE WHEN YEAR(date) = 2021 THEN total_deaths ELSE 0 END) / SUM(CASE WHEN YEAR(date) = 2021 THEN population ELSE 0 END)) * 100 as death_percentage_2021,
    (SUM(CASE WHEN YEAR(date) = 2022 THEN total_deaths ELSE 0 END) / SUM(CASE WHEN YEAR(date) = 2022 THEN population ELSE 0 END)) * 100 as death_percentage_2022
FROM covid_dataset
WHERE YEAR(date) IN (2021, 2022)
GROUP BY continent;

-- Slide 7 - Mortality rate by age
SELECT
continent,
SUM(total_deaths) as total_death,
ROUND((SUM(aged_65_older) / SUM(total_deaths)) * 100, 2) as mortality_65yr_old,
ROUND((SUM(aged_70_older) / SUM(total_deaths)) * 100, 2) as mortality_70yr_old
FROM covid_dataset
WHERE YEAR(date) = 2022
GROUP BY continent;

-- Slide 8 - Comparing new cases per million with population density
SELECT
continent,
ROUND(AVG(new_cases_per_million),2) AS avg_newcases_pm,
ROUND(AVG(population_density),2) AS avg_population_density
FROM covid_dataset
GROUP BY continent;

-- Slide 9 - Comparing make VS female smokers' death rate after COVID
SELECT
continent,
ROUND((SUM(CASE WHEN YEAR(date) = 2021 THEN total_deaths ELSE 0 END) / SUM(CASE WHEN YEAR(date) = 2021 THEN population ELSE 0 END)) * 100, 2) as death_rate_2021,
ROUND((SUM(CASE WHEN YEAR(date) = 2021 THEN total_deaths ELSE 0 END) / SUM(CASE WHEN YEAR(date) = 2021 THEN (population * female_smokers / 100) ELSE 0 END)) * 100, 2) as deathrate_F_smokers2021,
ROUND((SUM(CASE WHEN YEAR(date) = 2021 THEN total_deaths ELSE 0 END) / SUM(CASE WHEN YEAR(date) = 2021 THEN (population * male_smokers / 100) ELSE 0 END)) * 100, 2) as deathrate_M_smokers2021
FROM covid_dataset
WHERE YEAR(date) = 2021 AND MONTH(date) = 12
GROUP BY continent;
    
-- Slide 10 - Finding which country has the highest completely vaccinated people WRT to population
SELECT
location, ((SUM(people_fully_vaccinated) + SUM(total_boosters)) / SUM(population)) * 100 as completely_vaccinated
FROM covid_dataset
WHERE YEAR(date) = 2022 
AND location NOT IN ('Asia', 'World', 'Upper middle income', 'Lower middle income', 'High income', 'Low income', 'Europe', 'North America', 'South America', 'European Union')
GROUP BY location
ORDER BY completely_vaccinated DESC
LIMIT 10;


--1.
-- cal the percentage of covid death per total cas
SELECT sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)* 100 as DeathPercentage
from PorfolioProject..CovidDeaths
where continent is not null
order by 1, 2


--2 


Select location , SUM(cast(new_deaths as int)) as TotalDeathCount
from PorfolioProject..CovidDeaths
where continent is null
and location not in ('World', 'European Union', 'International')
group by location
order by  TotalDeathCount desc


--3

-- Looking at Countries with highest infection rate  compared to  population
Select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))* 100 as PercentPopulationInfected
from PorfolioProject..CovidDeaths
--where location like '%states%'
group by location, population
order by PercentPopulationInfected desc


--4.

Select location, population, date,  max(total_cases) as highestInfectionCount, max((total_cases/population))* 100 as PercentPopulationInfected
from PorfolioProject..CovidDeaths
--where location like '%states%'
group by location, population, date
order by PercentPopulationInfected desc

select * from PorfolioProject..CovidDeaths
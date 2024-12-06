Select * from PorfolioProject..CovidDeaths
where continent is not null
order by 4,5


--Select * from PorfolioProject..CovidVaccinations
--order by 3,4


Select location, date , total_cases, new_cases, total_deaths, population
from PorfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Looking at total_cases and total_deaths

Select location, date , total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
from PorfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

-- Looking at total_cases and population

--show percentage of people got covid
Select location, date , population, total_cases, (total_cases/population)* 100 as PercentPopulationInfected
from PorfolioProject..CovidDeaths
--where location like '%states%'
order by 1,2

-- Looking at Countries with highest infection rate  compared to  population
Select location, population, max(total_cases) as highestInfectionCount, max((total_cases/population))* 100 as PercentPopulationInfected
from PorfolioProject..CovidDeaths
--where location like '%states%'
group by location, population
order by PercentPopulationInfected desc

--desc giam asc tang


-- showing countries with highest death count per population

Select location , max(cast(total_deaths as int)) as TotalDeathCount
from PorfolioProject..CovidDeaths
where continent is not null
group by location
order by  TotalDeathCount desc


-- showing continent with highest death count per population
Select location , max(cast(total_deaths as int)) as TotalDeathCount
from PorfolioProject..CovidDeaths
where continent is null
group by location
order by  TotalDeathCount desc


-- GLOBAL NUMBERS


-- new cases everyday in the world
SELECT date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)
* 100 as deathPercentage
from PorfolioProject..CovidDeaths
where continent is not null
group by date
order by 1



select * from PorfolioProject..CovidVaccinations
--Looking at Total population vs Vaccinations


--use CTE(common table expression)
With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/dea.population)*100
from PorfolioProject..CovidVaccinations vac 
	join PorfolioProject..CovidDeaths dea 
On dea.location = vac.location and 
	dea.date =vac.date
where dea.continent is not null
--order by 2,3
)

Select * , (RollingPeopleVaccinated/Population)*100
From PopVsVac


--TEMP TABLE


Create table #PercentPopulationVaccinated(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/dea.population)*100
from PorfolioProject..CovidVaccinations vac 
	join PorfolioProject..CovidDeaths dea 
On dea.location = vac.location and 
	dea.date =vac.date
where dea.continent is not null

Select * , (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Create view to store data for later visulizations

Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date , dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/dea.population)*100
from PorfolioProject..CovidVaccinations vac 
	join PorfolioProject..CovidDeaths dea 
On dea.location = vac.location and 
	dea.date =vac.date
where dea.continent is not null
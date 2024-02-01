Select *
From PortfolioProject..CovidDeaths
WHERE continent is not null
order by 3,4

Select *
From PortfolioProject..CovidVaccinations
order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%japan%' and continent is not null
order by 1,2


--WITH CTE_CovidDeaths as
--(Select Location, date, total_cases, total_deaths, CAST(((total_deaths/total_cases)*100) as DECIMAL(10,3)) as DeathPercentage
--From PortfolioProject..CovidDeaths)
--select *
--From CTE_CovidDeaths
--order by 1,2

Select location, date, population, total_cases, (total_cases / population)*100 as InfectionRate
From PortfolioProject..CovidDeaths
Where location like '%state%'
order by 1,2




Select location, population, Max(total_cases) as HighestInfectionCount, MAX(total_cases / population)*100 as InfectionRate
From PortfolioProject..CovidDeaths
Group by location, population
order by InfectionRate desc



Select location, population, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--WHERE location like 'japan'
WHERE continent is null
Group by location, population
order by TotalDeathCount desc


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathsPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
--group by date
order by 1,2


Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, 
 dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null and vac.new_vaccinations is not null
order by 2,3

-- CTE

WITH PopvsVac (continent, location, date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, 
 dea.Date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255), 
location nvarchar(255), 
date datetime, 
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, 
 dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location and dea.date = vac.date
--WHERE dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%japan%' and continent is not null
order by 1,2


-- Create View to store date for later visualization

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, 
 dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null --and vac.new_vaccinations is not null
--order by 2,3
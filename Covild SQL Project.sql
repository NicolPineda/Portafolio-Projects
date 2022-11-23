
Select *
From [Portolio Project].dbo.CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From [Portolio Project].dbo.CovidVaccinations
--order by 3,4

--Select Data that we are goint to use

Select location, date, total_cases, new_cases, total_deaths, population
Where continent is not null
From [Portolio Project].dbo.CovidDeaths
order by 1,2

--Total cases vs Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portolio Project].dbo.CovidDeaths
Where location like'%states%'
and continent is not null
order by 1,2


--Total Cases vs Population
--It will be show the population percentage that got covid 
Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From [Portolio Project].dbo.CovidDeaths
Where location like'%states%'
order by 1,2

--Countries with the highest rate of cases compared to the population
Select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
From [Portolio Project].dbo.CovidDeaths
--Where location like'%states%'
Group by location, population
order by PercentPopulationInfected desc

--Showing Countries with Highest Deat Count per Population 
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portolio Project].dbo.CovidDeaths
--Where location like'%states%'
Where continent is not null
Group by location
order by TotalDeathCount desc


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Portolio Project].dbo.CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

--Filtering by continent
--Continents with the Highest Death Count
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portolio Project].dbo.CovidDeaths
--Where location like'%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Global numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [Portolio Project].dbo.CovidDeaths
--Where location like'%states%'
where continent is not null
--Group by date
order by 1,2


--Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
From [Portolio Project].dbo.CovidDeaths dea
Join [Portolio Project].dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3,

--Use a CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portolio Project].dbo.CovidDeaths dea
Join [Portolio Project].dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3,
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Temp Tabe

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric, 
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portolio Project].dbo.CovidDeaths dea
Join [Portolio Project].dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3,

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating View to store data for visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select * 
From PercentPopulationVaccinated
select * 
from [Portofolio Project]..CovidDeaths
where continent is not null
order by 3,4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portofolio Project]..CovidDeaths
Where continent is not null 
order by 1,2




-- looking at Total Cases vs Total Deaths 
--Shows the Likelihood of dying if you contacct covid in your country 
select location,date,total_cases, total_deaths,(total_deaths/total_cases)*100 as Deathpercentage 
from [Portofolio Project]..CovidDeaths
where location like '%States%'
and continent is not null 
order by 1,2


-- looking at Total Cases vs Population
-- Shows what percantage of population infected with Covid

select location, continent ,date,population,total_cases,(total_cases/population)*100 as 
percentagepopulationinfected
from [Portofolio Project]..CovidDeaths
where continent is not null
--where location like '%States%'
order by 1,2

-- looking at Countraies with Highest Infection Rates compared to Population 

select location, population ,max(total_cases)as HighestInfectioncount , max((total_cases/population)*100)as 
percentagepopulationinfected
from [Portofolio Project]..CovidDeaths
--where location like '%States%'
where continent is not null
group by location,population
order by percentagepopulationinfected desc 

--Showing Countrries with Highest Death Count per Population 
select location,max(cast(total_deaths as int))as Totaldeathscount 
from [Portofolio Project]..CovidDeaths
--where location like '%States%'
where continent is not null
group by location
order by Totaldeathscount desc 


--Let's Break Things Down by Continent 
select continent ,max(cast(total_deaths as int))as Totaldeathscount 
from [Portofolio Project]..CovidDeaths
--where location like '%States%'
where continent is not null
group by continent
order by Totaldeathscount desc 



--showing continenes with the highest death count per population 

select continent,max(cast(total_deaths as int))as Totaldeathscount 
from [Portofolio Project]..CovidDeaths
--where location like '%States%'
where continent is not null
group by continent
order by Totaldeathscount desc


-- looking at Continentes with Highest Infection Rates compared to Population 
SELECT 
    continent, 
    MAX(population) AS population,
    MAX(total_cases) AS HighestInfectionCount, 
    MAX((total_cases/population)*100) AS PercentagePopulationInfected
FROM [Portofolio Project]..CovidDeaths
WHERE continent IS not  NULL
GROUP BY continent
ORDER BY PercentagePopulationInfected DESC

--Golbal Numbers
select sum(new_cases )as Total_Cases,sum (cast(new_deaths as int) )as Total_Deaths,sum(cast (new_deaths as int))
/sum(new_cases )*100
as Deathpercentage
from [Portofolio Project]..CovidDeaths
--where location like '%States%'
where continent is not null 
--group by date
order by 1,2





--looking at Total Population vs Vaccinattions

select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
,sum(cast (vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location 
,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from [Portofolio Project]..CovidDeaths dea
join [Portofolio Project]..CovidVaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- Using CTE to perform Calculation on Partition By in previous query


with popvsvac (Continent ,location ,population,date, new_vaccinations ,RollingPeopleVaccinated)
as
(
select  dea.continent,dea.location,dea.population ,dea.date, vac.new_vaccinations
,sum(cast (vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location 
,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from [Portofolio Project]..CovidDeaths dea
join [Portofolio Project]..CovidVaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated /population )*100 as firstofpopvsvac_cte
from popvsvac 


 
 
create table #prercentagepeoplevaccinated

(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric

)
insert into  #prercentagepeoplevaccinated
select  dea.continent,dea.location,dea.date,dea.population ,vac.new_vaccinations
,sum(cast (vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location 
,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from [Portofolio Project]..CovidDeaths dea
join [Portofolio Project]..CovidVaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * ,(RollingPeopleVaccinated /population )*100
from #prercentagepeoplevaccinated








--Temp Table to perform Calculation on Partition By in previous query



drop table if exists  #prercentagepeoplevaccinated 
create table #prercentagepeoplevaccinated

(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric

)
insert into  #prercentagepeoplevaccinated
select  dea.continent,dea.location,dea.date,dea.population ,vac.new_vaccinations
,sum(cast (vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location 
,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from [Portofolio Project]..CovidDeaths dea
join [Portofolio Project]..CovidVaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select * ,(RollingPeopleVaccinated /population )*100
from #prercentagepeoplevaccinated

--creating viwes to store data for visualiztions 
create view prercentagepeoplevaccinated as 
select  dea.continent,dea.location,dea.date,dea.population ,vac.new_vaccinations
,sum(cast (vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location 
,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from [Portofolio Project]..CovidDeaths dea
join [Portofolio Project]..CovidVaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * 
from prercentagepeoplevaccinated 

create database CovidDeaths;
select * from coviddeaths.deaths;
  
select * from coviddeaths.Vaccinations;


#Select data that we are goin to be using

Select Location, date, total_cases, new_cases, total_deaths, population
from coviddeaths.deaths 
order by Location asc,
YEAR(date) asc, MONTH(date) asc, DAY(date) asc 
;
#Total cases vs total deaths in Albania

Select Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage 
from coviddeaths.deaths  where location = 'Albania'
order by Location asc, 
YEAR(date) asc, MONTH(date) asc, DAY(date) asc 
 ;
#Total cases vs Population
Select Location, date, total_cases, population, total_deaths, (total_cases/population)*100 AS DeathPercentage 
from coviddeaths.deaths  
where location = 'Albania'
order by Location asc, 
YEAR(date) asc, MONTH(date) asc, DAY(date) asc 

#Countries of highest infection Rate compared to Population
;
Select Location, MAX(total_cases) AS HighestinfectionCount, population, MAX((total_cases/population))*100 AS pERCENTPOPULATININFECTED 
from coviddeaths.deaths  
group by population,Location
order by  pERCENTPOPULATININFECTED desc

#Countriesd with highest death count per population
;
Select Location, MAX(cast(total_deaths as float)) AS HighestdeathCount, population, MAX((total_deaths/population))*100 AS Percentagedead 
from coviddeaths.deaths  
group by  Location
order by  HighestdeathCount  desc


#Sorting deaths by continent
;


#Showing continents with the highest death count per population
 Select continent, MAX(cast(total_deaths as float)) AS totaldeathCount, population
from coviddeaths.deaths  
where continent is not null
group by  continent
order by  totaldeathCount  desc
;


#Global numbers
Select Location,new_cases, date, SUM(new_cases) #,  total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage 
from coviddeaths.deaths  
 group by date
order by Location asc, 
YEAR(date) asc, MONTH(date) asc, DAY(date) asc 
;

#Total death percentage across the world
Select  SUM(new_cases) as totalcases, SUM(cast(new_deaths as float)) as totaldeaths,SUM(cast(new_deaths as float))/SUM(new_cases)*100 as DEathPercentage
from coviddeaths.deaths  
#group by location 
#order by date asc, 
#YEAR(date) asc, MONTH(date) asc, DAY(date) asc 

;


#Looking at total population vs Vaccinations
With PopvsVac(population, continent,location,date,new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.population, dea.continent,dea.location,dea.date,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as float)) as RollingPeopleVaccinated
#((RollingPeopleVaccinated/population)*100)
from coviddeaths.deaths dea
Join coviddeaths.vaccinations vac
on dea.Location =vac.location
where dea.continent is not null
and dea.date != vac.date
)

select *,(RollingPeopleVaccinated/population)*100
From PopvsVAc
 
#TEMP TABLE
;
create Table PercentPopulationVaccinated1
(
population int,
Continent varchar(255),
location varchar(255),
Date datetime,
New_Vaccinations int,
RollingPeopleVaccinated numeric
);

Insert into PercentPopulationVaccinated1
(
Select dea.population, dea.continent,dea.location,dea.date,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as float)) as RollingPeopleVaccinated
#((RollingPeopleVaccinated/population)*100)
from coviddeaths.deaths dea
 Join coviddeaths.vaccinations vac
 on dea.continent =vac.continent
where dea.continent is not null
and dea.date != vac.date
)

 #create  view  to store data for later visualizations
 ;
 create View PercentPopulationVaccinated2 as 
 Select dea.population, dea.continent,dea.location,dea.date,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as float)) as RollingPeopleVaccinated
#((RollingPeopleVaccinated/population)*100)
from coviddeaths.deaths dea
Join coviddeaths.vaccinations vac
on dea.Location =vac.location
where dea.continent is not null
and dea.date != vac.date


--select data that we are going to use 

select location , date , total_cases , new_cases , total_deaths , population 
from PorfolioProject..CovidDeaths
order by 1,2;


--looking at total cases vs total deaths (how many cases per deaths in location)
--shows the chance of dying from covid is you are positive and live in the Mexico 
select location , date , total_cases, total_deaths , (total_deaths /total_cases) * 100 as 'Death Percentage'
from PorfolioProject..CovidDeaths
where location like '%mexico%'
order by 1,2;



--looking at total cases vs population
--shows percentage of peopel with covid from the whole population
select location , date , Population,total_cases, (total_cases /population) * 100 as 'PercentPopulationInfected'
from PorfolioProject..CovidDeaths
where location like '%mexico%'
order by 1,2;


--looking at countries with highest infection rate compared to population 
select location , population , max(total_cases) as HighestInfectionCount ,
		max( (total_cases /population) )* 100 as PercentPopulationInfected
from PorfolioProject..CovidDeaths
group by location , population 
order by PercentPopulationInfected desc; 



--this is showing the countries with the highest death count per population 
select location , max ( cast (total_deaths as  int ) )as TotalDeathCount
from PorfolioProject..CovidDeaths
where continent is not null
group by location 
order by TotalDeathCount desc;


--showing continents with the highest death count 
select location , max ( cast (total_deaths as  int ) )as TotalDeathCount
from PorfolioProject..CovidDeaths
where continent is not null
group by continent 
order by TotalDeathCount desc;

--global numbers 
select sum(new_cases) as total_cases , sum (convert(int , new_deaths)) as total_deaths ,
	   sum(convert (int , new_deaths)) / sum(new_cases) * 100 as 'Death Percentage'
from PorfolioProject..CovidDeaths
where continent is not null 
order by 1 , 2; 


--joining two tables togehter vaccines info and death info 




--looking at total population vs vaccinations 
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations,
	sum (convert(int, vac.new_vaccinations)) over (Partition by dea.Location order by dea.location , dea.date) as 
	'Rolling Vaccinated'
from PorfolioProject..CovidDeaths dea
join PorfolioProject..CovicVaccines	vac 	
		on dea.location = vac.location 
		and dea.date = vac.date
where dea.continent is not null 
Order by 2 ,3 ;

--create a view to store for later visuals 

Create view PercentPopulationVaccinated_view  
as 
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations,
	sum (convert(int, vac.new_vaccinations)) over (Partition by dea.Location order by dea.location , dea.date) as 
	RollingPeopleVaccinated
from PorfolioProject..CovidDeaths dea
join PorfolioProject..CovicVaccines	vac 	
		on dea.location = vac.location 
		and dea.date = vac.date
where dea.continent is not null ;


select * 
from PercentPopulationVaccinated_view;

















-----------------------------------------------
-- Ransom Events - incident involved a demand of monetary ransom
-----------------------------------------------

-- table of all the ransom incidents that occurred in a known city 
create temporary table ransom_demanded as
select *
from globalterrorism
where globalterrorism.ransom = '1' 
	and globalterrorism.city != 'Unknown'
	and globalterrorism.city != 'unknown'
	and globalterrorism.city != ''

-- add column date 
-- "Incidents from the GTD follow a 12-digit Event ID system.
--		• First 8 numbers – date recorded “yyyymmdd”"
alter table ransom_demanded add column date_ datetime;
update ransom_demanded
set date_ = substr(ransom_demanded.eventid, 0, 5) ||'-'|| 
				substr(ransom_demanded.eventid, 5, 2) ||'-'|| 	
				substr(ransom_demanded.eventid, 7, 2)
------------------------------------
-- count the number of ransom incidents in the same city that happened in the following year
------------------------------------
create temporary table ransom_city as
select b.city as city,
		b.date_ as date_, 
		b.ransomamt as ransomamt, 
		b.ransompaid as ransompaid ,
		count(*) as times
from
(select ransom_demanded.eventid, ransom_demanded.date_, ransom_demanded.city 
	from ransom_demanded) as a 
join
(select ransom_demanded.eventid, ransom_demanded.date_, ransom_demanded.city,
	ransom_demanded.ransomamt, ransom_demanded.ransompaid
	from ransom_demanded) as b
on a.date_ between b.date_ and date(b.date_, '+1 year')
and a.city = b.city
group by b.eventid
order by b.city

-- the probability for a ransom incidents in the city in the following year
select sum(occurrence)/cast(count(*) as double)
from
(select case when times = 1 then 0
				when times > 1 then 1
				end as occurrence
from ransom_city)

-- the probability for a ransom incidents in the city in the following year
-- if a ransom amount was paid 
select sum(occurrence)/cast(count(*) as double)
from
(select case when times = 1 then 0
				when times > 1 then 1
				end as occurrence
from ransom_city
	where ransom_city.ransompaid > '1')
	
------------------------------------	
-- count the number of ransom incidents in the same country that happened in the following year
------------------------------------
create temporary table ransom_country as
select b.country as country,
		b.date_ as date_, 
		b.ransomamt as ransomamt, 
		b.ransompaid as ransompaid ,
		count(*) as times
from
(select ransom_demanded.eventid, ransom_demanded.date_, ransom_demanded.country 
	from ransom_demanded) as a 
join
(select ransom_demanded.eventid, ransom_demanded.date_, ransom_demanded.country,
	ransom_demanded.ransomamt, ransom_demanded.ransompaid
	from ransom_demanded) as b
on a.date_ between b.date_ and date(b.date_, '+1 year')
and a.country = b.country
group by b.eventid
order by b.country

-- the probability for a ransom incidents in the city in the following year
select sum(occurrence)/cast(count(*) as double)
from
(select case when times = 1 then 0
				when times > 1 then 1
				end as occurrence
from ransom_country)

-- the probability for a ransom incidents in the city in the following year
-- if a ransom amount was paid 
select sum(occurrence)/cast(count(*) as double)
from
(select case when times = 1 then 0
				when times > 1 then 1
				end as occurrence
from ransom_country
	where ransom_country.ransompaid > '1')
	
------------------------------------
-- list of incidents where the amount that was paid is bigger than demanded
------------------------------------
select *
from ransom_city
where ransom_city.ransomamt > '1' 
		and ransom_city.ransompaid > '1'
		and ransom_city.ransompaid - ransom_city.ransomamt > 1




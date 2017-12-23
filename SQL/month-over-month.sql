-- Month-Over-Month Growth Rate 
select b.month_2015, b.month_crimes, cast(b.month_crimes as double)/a.month_crimes - 1 as growth_rate
from
(select cast(substr(Crimes_2015.Date, 1, 2)as int) as index_,
	substr(Crimes_2015.Date, 0, 3) || '-' || substr(Crimes_2015.Date, 7, 4) as month_2015,
	count(*) as month_crimes
from Crimes_2015
group by month_2015) as a 
join
(select cast(substr(Crimes_2015.Date, 1, 2)as int) as index_,
	substr(Crimes_2015.Date, 0, 3) || '-' || substr(Crimes_2015.Date, 7, 4) as month_2015,
	count(*) as month_crimes
from Crimes_2015
group by month_2015) as b
on a.index_ +1 = b.index_
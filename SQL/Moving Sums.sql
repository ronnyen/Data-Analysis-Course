select  interval_1.from_date, interval_1.to_date, 
		CASE WHEN interval_1.total_1 IS NULL
			 THEN 0
			 ELSE interval_1.total_1
			 END AS total_1,
		interval_7.from_date, interval_7.to_date,
		CASE WHEN interval_7.total_7 IS NULL
			 THEN 0
			 ELSE interval_7.total_7
			 END AS total_7,
		interval_14.from_date, interval_14.to_date, 
		CASE WHEN interval_14.total_14 IS NULL
			 THEN 0
			 ELSE interval_14.total_14
			 END AS total_14,
		interval_28.from_date, interval_28.to_date, 
		CASE WHEN interval_28.total_28 IS NULL
			 THEN 0
			 ELSE interval_28.total_28
			 END AS total_28
			 
			from (select DATE(x, '-1 day') AS from_date,
				x as to_date,
				y + cast(julianday('2013-12-31') - julianday(x)as int) as interval, 
				sum(total) total_1
			from(WITH RECURSIVE interval_(y) AS (
										VALUES(1)
										UNION ALL
										SELECT y+1 FROM interval_ WHERE y < 1)
			select * from interval_) interval_
			cross join
			(select * from (
			WITH RECURSIVE all_dates(x) AS (
										VALUES('2009-01-01')
										UNION ALL
										SELECT date(x, '+1 day')
										FROM all_dates
										WHERE  x < '2013-12-31')

			select * from all_dates) as a
			left join
			(select strftime('%Y-%m-%d', Invoice.InvoiceDate) as date_, Invoice.Total
			from Invoice) i
			on a.x = i.date_)
			group by interval
			having interval >1
			order by from_date desc) interval_1
join
		(select DATE(x, '-7 day') AS from_date,
			x as to_date,
			y + cast(julianday('2013-12-31') - julianday(x)as int) as interval, 
			sum(total) as total_7
		from
		(WITH RECURSIVE interval_(y) AS (
									VALUES(1)
									UNION ALL
									SELECT y+1 FROM interval_ WHERE y < 7)
		select * from interval_) interval_
		cross join
		(select *
		from (
		WITH RECURSIVE all_dates(x) AS (
									VALUES('2009-01-01')
									UNION ALL
									SELECT date(x, '+1 day')
									FROM all_dates
									WHERE  x < '2013-12-31')

		select * from all_dates) as a
		left join
		(select strftime('%Y-%m-%d', Invoice.InvoiceDate) as date_, Invoice.Total
		from Invoice) i
		on a.x = i.date_)
		group by interval
		having interval > 7
		order by from_date desc) interval_7
		on interval_1.to_date = interval_7.to_date 
join 
		(select DATE(x, '-14 day') AS from_date,
			x as to_date,
			y + cast(julianday('2013-12-31') - julianday(x)as int) as interval, 
			sum(total) as total_14
		from(WITH RECURSIVE interval_(y) AS (
									VALUES(1)
									UNION ALL
									SELECT y+1 FROM interval_ WHERE y < 14)
		select * from interval_) interval_
		cross join
		(select *
		from (
		WITH RECURSIVE all_dates(x) AS (
									VALUES('2009-01-01')
									UNION ALL
									SELECT date(x, '+1 day')
									FROM all_dates
									WHERE  x < '2013-12-31')

		select * from all_dates) as a
		left join
		(select strftime('%Y-%m-%d', Invoice.InvoiceDate) as date_, Invoice.Total
		from Invoice) i
		on a.x = i.date_)
		group by interval
		having interval > 14
		order by from_date desc) interval_14
		on interval_1.to_date = interval_14.to_date
join
		(select DATE(x, '-28 day') AS from_date,
			x as to_date,
			y + cast(julianday('2013-12-31') - julianday(x)as int) as interval, 
			sum(total) total_28
		from (WITH RECURSIVE interval_(y) AS (
									VALUES(1)
									UNION ALL SELECT y+1 FROM interval_ WHERE y < 28)
		select * from interval_) interval_
		cross join
		(select *
		from (
		WITH RECURSIVE all_dates(x) AS (
									VALUES('2009-01-01')
									UNION ALL
									SELECT date(x, '+1 day')
									FROM all_dates
									WHERE  x < '2013-12-31')

		select * from all_dates) as a
		left join
		(select strftime('%Y-%m-%d', Invoice.InvoiceDate) as date_, Invoice.Total
		from Invoice) i
		on a.x = i.date_)
		group by interval
		having interval >28
		order by from_date desc) interval_28
on interval_1.to_date = interval_28.to_date
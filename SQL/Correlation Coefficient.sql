--r(x, y)
-- I made an approximation of square root 
-- as mentiones here: https://stackoverflow.com/questions/12731941/how-to-calculate-square-root-in-sqlite
--
---- The correlation between age of user and number of likes that he gave
select cov / (s_dev_x * s_dev_y) as 'r(x, y)'
from
(select sum(dataTable_1.dx * dataTable_1.dx) / (1547-1) as cov,
		--standard deviation of x
		31.6227766 + 0.007597469 * (sum (dataTable_1.dx * dataTable_1.dx) / (1547-1)-1000) as s_dev_x,
		--standard deviation of y
		100 + 0.002402530729 * (sum (dataTable_1.dy * dataTable_1.dy) / (1547 - 1) - 10000) as s_dev_y
	from 
	(select *, 
			dataTable.x - avg_x.avg_x as dx,
			dataTable.y - avg_y.avg_y as dy,
			(dataTable.x - avg_x.avg_x) * (dataTable.y - avg_y.avg_y) as dx_dy		
			from (select users.id, 
						users.age as x, 
						count(likes.id) as y, 
						users.age * count(likes.id) as xy,
						users.age * users.age as x2,
						count(likes.id) * count(likes.id) as y2		
						from users left join likes
						on users.id=likes.user_id
						group by users.id) as dataTable
					-- add average x column
					join
						(select cast(sum(users.age)as double) / 1547 as avg_x
							from users)as avg_x
					-- add average y column
					join
						(select cast(count(*)as double) / 1547 as avg_y
							from likes) as avg_y) as dataTable_1);
							
---- The correlation between age of user and number of comments that he wrote
select cov / (s_dev_x * s_dev_y) as 'r(x, y)'
from
(select sum(dataTable_1.dx * dataTable_1.dx) / (1547-1) as cov,
		--standard deviation of x
		31.6227766 + 0.007597469 * (sum (dataTable_1.dx * dataTable_1.dx) / (1547-1)-1000) as s_dev_x,
		--standard deviation of y
		100 + 0.002402530729 * (sum (dataTable_1.dy * dataTable_1.dy) / (1547 - 1) - 10000) as s_dev_y
	from 
	(select *, 
			dataTable.x - avg_x.avg_x as dx,
			dataTable.y - avg_y.avg_y as dy,
			(dataTable.x - avg_x.avg_x) * (dataTable.y - avg_y.avg_y) as dx_dy		
			from (select users.id, 
						users.age as x, 
						count(comments.id) as y, 
						users.age * count(comments.id) as xy,
						users.age * users.age as x2,
						count(comments.id) * count(comments.id) as y2		
						from users left join comments
						on users.id=comments.user_id
						group by users.id) as dataTable
					-- add average x column
					join
						(select cast(sum(users.age)as double) / 1547 as avg_x
							from users)as avg_x
					-- add average y column
					join
						(select cast(count(*)as double) / 1547 as avg_y
							from comments) as avg_y) as dataTable_1)
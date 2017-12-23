-- Simple Linear Regression Equation
-- 
---- The relationship between age of user and number of likes that he gave
select cast((sum(y) * sum(x2) - sum(x) * sum(xy)) as double)/
		cast((1547 * sum(x2) - sum(x) * sum(x))as double) as intercept,
		cast((1547 * sum(xy)- sum(x) * sum(y))as double)/ 
		cast((1547 * sum(x2) - sum(x) * sum(x))as double) as slope
from(select users.id, 
			users.age as x, 
			count(likes.id) as y, 
			users.age * count(likes.id) as xy,
			users.age * users.age as x2,
			count(likes.id) * count(likes.id) as y2		
			from users left join likes
			on users.id=likes.user_id
			group by users.id) as dataTable;
			
---- The relationship between age of user and number of comments
select cast((sum(y) * sum(x2) - sum(x) * sum(xy)) as double)/
		cast((1547 * sum(x2) - sum(x) * sum(x))as double) as intercept,
		cast((1547 * sum(xy)- sum(x) * sum(y))as double)/ 
		cast((1547 * sum(x2) - sum(x) * sum(x))as double) as slope
from(select users.id, 
			users.age as x, 
			count(comments.id) as y, 
			users.age * count(comments.id) as xy,
			users.age * users.age as x2,
			count(comments.id) * count(comments.id) as y2		
			from users left join comments
			on users.id=comments.user_id
			group by users.id) as dataTable;
						

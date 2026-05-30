
# remove duplicates

select distinct * from `list of orders`;
select distinct * from `order details`;
select distinct * from `sales target`;

# using group by and order by

select `category`,sum(target) as `total target` from `sales target`
group by `Category`
order by `total target` desc;

# joins and group by and order by

select `s`.`CustomerName`,sum(`o`.amount) as `total amount` from `list of orders` s
join `order details` o on `s`.`Order id`=`o`.`Order ID`
group by `s`.`CustomerName`
order by `total amount` desc;

#filtering and sorting amount above 500 in `order details` table

select * from `order details` 
where amount > 500
order by `Amount` desc;

#seeing sum of amount and high to low

select `order id`,sum(amount) as `total amount`,
       case
           when sum(amount) > 1000 then 'high'
           when sum(amount) > 500 then 'medium'
           else 'low'
       end as `amount level`
from `order details`
group by `order id`
order by `total amount` desc ;
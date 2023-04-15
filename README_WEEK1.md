1. How many users do we have?
Answer: 130 users

<query>


```sql

select count(distinct users_guid) from dev_db.dbt_paganioyahoocom.stg_postgres__users;

```

</query>

2. On average, how many orders do we receive per hour?
Answer: 7.52 orders per hour

<query>


```sql

with orders_count as (

    select 
        date_trunc(hour, created_at_utc) as hour_created
        , count (*) as order_count
    from 
        dev_db.dbt_paganioyahoocom.stg_postgres__orders 
    group by 1
    
)

select round(avg(order_count),2) from orders_count

```

</query>

3. On average, how long does an order take from being placed to being delivered?
Answer: 3.89 days

<query>


```sql

with base as (

    select
        datediff(day, created_at_utc, delivered_at_utc) as duration_in_days
    from
        dev_db.dbt_paganioyahoocom.stg_postgres__orders 
    
)

select round(avg(duration_in_days),2) from base 

```

</query>

4. How many users have only made one purchase? Two purchases? Three+ purchases?
Answer: 1 purchase: 25 users, 2 purchases: 28 users, 3+ purchases: 71 users

<query>


```sql

with user_orders as (

    select
        user_guid
        , count(*) as count_orders
    from 
        dev_db.dbt_paganioyahoocom.stg_postgres__orders   
    group by 1

)

select
  case count_orders
    when 1 then '1'
    when 2 then '2'
    else '3+'
  end as cohort
  , count(distinct user_guid) as count_users 
from 
    user_orders
group by 1
order by 1

```

</query>

5. On average, how many unique sessions do we have per hour?
Answer: 16.33

<query>


```sql

with unique_sessions as (

    select 
        date_trunc(hour, created_at_utc) as created_hours
         , count(distinct(session_guid)) as unique_session_count
    from 
        dev_db.dbt_paganioyahoocom.stg_postgres__events 
    group by 1
    
)

select round(avg(unique_session_count),2) from unique_sessions

```

</query>
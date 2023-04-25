### Part 1. Models

---

#### 1. What is our user repeat rate?

**79.8387%**

###### Repeat Rate = Users who purchased 2 or more times / users who purchased.

<details>
  
<summary>Query</summary>
  
</br>
  
```sql
with orders_cohort as (

    select
    user_guid
    , count(distinct order_guid) as user_orders
    from
        dev_db.dbt_paganioyahoocom.stg_postgres__orders
    group by 1
    
)

, users_bucket as (

    select
        user_guid
        , (user_orders = 1)::int as has_one_purchases
        , (user_orders = 2)::int as has_two_purchases
        , (user_orders = 3)::int as has_three_purchases
        , (user_orders >= 2)::int as has_two_plus_purchases
    from
        orders_cohort
        
)

select
    sum(has_one_purchases) as one_purchases
    , sum(has_two_purchases) as two_purchases
    , sum(has_three_purchases) as three_purchases
    , sum(has_two_plus_purchases) as two_plus_purchases
    , count(distinct user_guid) as num_user_w_purchases
    , div0(two_plus_purchases, num_user_w_purchases) as repeat_rate
from
    users_bucket
```
  
</details>

<details>
  
<summary>Result</summary>
  
</br>
  
| NUM_USER_W_PURCHASES | TWO_PLUS_PURCHASES    | RATE_REPEAT | 
| -------------------- | --------------------- | ----------- |
| 124                  | 99                    | 79.8387     |
  
</details>

#

#### 2. What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

###### This is a hypothetical question 

Some hypothetical indicators of a user who will likely purchase again:
- Look into percentage of customers that purchase two plus products as an indicator that they will be coming back
- Concentrate on the new customers offering promo codes so they will place more orders
- With more data one could find a correlation between products and demographic area and age and gender.

#

#### 3. Creating Marts Folder

• [Marts Folder with Business Units](https://github.com/opagani/course-dbt/tree/main/greenery/models/marts)

#

#### 4. Intermediate and Dim/Fact Models

• [Product](https://github.com/opagani/course-dbt/tree/main/greenery/models/marts/product)

• [Intermediate](https://github.com/opagani/course-dbt/tree/main/greenery/models/intermediate)

#

#### 5. Marts models

The product mart contains a model fct_page_views which contains all page view events from greenery’s events data

See [fct_page_views](https://github.com/opagani/course-dbt/blob/main/greenery/models/marts/product/fct_page_views.sql) model.

It also contains a model fct_user_sessions which measures the time each user spent on a session

See [fct_page_views](https://github.com/opagani/course-dbt/blob/main/greenery/models/marts/product/fct_user_sessions.sql) model.

#

#### 6. Use the dbt docs to visualize your model DAGs

![Week 2 DAG](https://github.com/opagani/course-dbt/blob/main/greenery/images/oscar-pagani-dag-project2.png "Week 2 DAG")

### Part 2. Tests

We added the following tests to my models:

• **Staging models**: [uniquness test and not null for the keys]

• **Marts**: [uniquness test and not null for some of the guid's]
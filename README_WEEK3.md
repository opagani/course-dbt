**Part 1: Create new models to answer the first two questions**

*1. What is our overall conversion rate?* Answer: 62.45%

<details>


```sql

{{
    config(
        materialized='table'
    )
}}

with int_sessions as(
    select * from {{ ref('int_session_events_agg_macro') }}
)

select 
    div0(sum(checkouts), count(distinct event_session_guid)) as checkout_rate
from int_sessions

```

</details>

*2. What is our conversion rate by product?*

| NAME                | DISTINCT_PAGE_VIEW_SESSIONS | DISTINCT_ORDER_SESSIONS | CONVERSION_RATE |
|---------------------|-----------------------------|-------------------------|-----------------|
| Pothos              | 61                          | 21                      | 0.344262        |
| Bamboo              | 67                          | 36                      | 0.537313        |
| Philodendron        | 62                          | 30                      | 0.483871        |
| Monstera            | 49                          | 25                      | 0.510204        |
| String of pearls    | 64                          | 39                      | 0.609375        |
| ZZ Plant            | 63                          | 34                      | 0.539683        |
| Snake Plant         | 73                          | 29                      | 0.397260        |
| Orchid              | 75                          | 34                      | 0.453333        |
| Birds Nest Fern     | 78                          | 33                      | 0.423077        |
| ...                 | ...                         | ...                     | ...             |

<details>

```sql

{{
    config(
        MATERIALIZED = 'table'
    )
}}

with orders as (
    select 
        product_id
        , order_sessions
    from {{ ref('int_order_sessions_per_product_agg') }}
)

, page_views as (
    select 
        product_id
        , page_view_sessions
    from {{ ref('int_page_view_sessions_per_product_agg') }}
)

, products as (
    select 
        product_guid, 
        name
    from {{ ref('stg_postgres__products')}}
)

select 
    products.name
    , page_views.page_view_sessions
    , orders.order_sessions
    , (orders.order_sessions / page_views.page_view_sessions) as conversion_rate
from page_views
left join orders on page_views.product_id = orders.product_id
left join products on page_views.product_id = products.product_guid

```

</details>

*3. Why might certain products be converting at higher/lower rates than others?*

There are several factors:  popularity, price, brand name, reviews, etc that could influence the shopper to make a purchase.


**Part 2: Create a macro to simplify part of a model(s)**

• [Macros Folder](https://github.com/opagani/course-dbt/tree/main/greenery/macros/unique_columns.sql)

**Part 3: Add a post hook to your project to apply grants to the role “reporting”.**

• [Macros Folder](https://github.com/opagani/course-dbt/tree/main/greenery/macros/grant_role.sql)

**Part 4: Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project**

• [greenery Folder](https://github.com/opagani/course-dbt/tree/main/greenery/packages.yml)

I installed three packages:  dbt_utils, dbt_expectations and dbt_codegen.

**Part 5: Show (using dbt docs and the model DAGs) how you have simplified or improved a DAG using macros and/or dbt packages.**

• [images Folder](https://github.com/opagani/course-dbt/tree/main/greenery/images/oscar-pagani-project3-dbt-dag.png)

**Part 6: dbt Snapshots**

*1. Which products had their inventory change from week 2 to week 3?*

Answer: Several products chnaged in the last week.  For example, Pothos (decreased from 20 to 0), Philodendron (decreased from 25 to 15), Bamboo (decreased from 56 to 44), etc.

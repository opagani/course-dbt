{{
  config(
    materialized='table'
  )
}}

with page_views_agg as (

    select * from {{ref('int_page_views_agg')}}

),

products as (

    select * from {{ref('stg_postgres__products')}}

)

select 
    page_views_agg.event_product_guid
    , products.name
    , page_views_agg.event_created_at_utc
    , page_views_agg.page_views
from page_views_agg
left join products 
    on page_views_agg.event_product_guid = products.product_guid


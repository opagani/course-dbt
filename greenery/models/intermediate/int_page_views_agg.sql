
 
{{
  config(
    materialized='table'
  )
}}

with events as(

    select * from {{ref('stg_postgres__events')}}

),

page_views_agg as (

    select 
        event_product_guid
        , event_created_at_utc
        , sum(case when event_type = 'page_view' then 1 else 0 end) as page_views
    from events
    group by 1, 2

)

select * from page_views_agg
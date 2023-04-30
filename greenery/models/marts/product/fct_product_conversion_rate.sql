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
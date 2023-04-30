{{
    config(
        MATERIALIZED = 'table'
    )
}}

with events as (
    select * from {{ ref('stg_postgres__events') }}
)

, order_items as ( 
    select * from {{ ref('stg_postgres__order_items')}}
)

, final as (
    select
        order_items.product_id
        , count(distinct event_session_guid) as page_view_sessions
    from events
    left join order_items on events.event_order_guid = order_items.order_guid
    group by 1
)

select * from final
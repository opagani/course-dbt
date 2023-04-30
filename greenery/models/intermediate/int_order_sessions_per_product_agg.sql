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

select
    order_items.product_id
    , count(distinct events.event_session_guid) as order_sessions
from events
left join order_items on events.event_order_guid = order_items.order_guid
where events.event_order_guid is not null
group by 1
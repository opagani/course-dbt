{{
    config(
        MATERIALIZED = 'table'
    )
}}

with events as (
    select * from {{ ref('stg_postgres__events') }}
)

select
    event_product_guid as product_id
    , count(distinct event_session_guid) as page_view_sessions
from events
where event_type = 'page_view'
group by 1
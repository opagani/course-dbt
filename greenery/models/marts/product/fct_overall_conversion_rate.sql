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
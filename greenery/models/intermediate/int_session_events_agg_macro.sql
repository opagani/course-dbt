{{
  config(
    materialized='table'
  )
}}

-- {% set event_types = dbt_utils.get_column_values(table=ref('stg_postgres__events'), column='event_type') %}
{{ get_column_values('stg_postgres__events', 'event_type') }}

select
    event_session_guid
    , event_created_at_UTC
    , event_user_guid
    {% for event_type in event_types %}
    , sum(case when event_type = '{{ event_type }}' then 1 else 0 end) as {{ event_type }}s
    {% endfor %}
from {{ ref('stg_postgres__events') }}
group by 1, 2, 3
with source as (
    select * from {{ source('postgres', 'events')}}
)

, renamed_recast as (
    select
        -- ids
        event_id as event_guid
        , session_id as session_guid
        , user_id as user_guid
        , order_id as order_guid
        , product_id as product_guid
        -- timestamps
        , created_at as created_at_utc
        -- events
        , page_url
        , event_type
    from source
)

select * from renamed_recast
with source as (
    select * from {{ source('postgres', 'events')}}
)

, renamed_recast as (
    select
        event_id as event_guid
        , session_id as event_session_guid
        , user_id as event_user_guid
        , event_type
        , created_at as event_created_at_utc
        , order_id as event_order_guid
        , product_id as event_product_guid
        , page_url
    from source
)

select * from renamed_recast
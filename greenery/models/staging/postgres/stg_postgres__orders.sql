with source as (
    select * from {{ source('postgres', 'orders')}}
)

, renamed_recast as (
    select
        -- ids
        order_id as order_guid
        , user_id as user_guid
        , address_id as address_guid
        , tracking_id as tracking_guid
        , promo_id as promo_desc
        -- timestamp
        , created_at as created_at_utc
        , estimated_delivery_at as estimated_delivery_at_utc
        , delivered_at as delivered_at_utc
        -- shipping
        , shipping_service
        , shipping_cost
        , status
        , order_cost
        , order_total
    from source
)

select * from renamed_recast
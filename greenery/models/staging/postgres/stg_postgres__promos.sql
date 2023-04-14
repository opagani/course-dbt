with source as (
    select * from {{ source('postgres', 'promos')}}
)

, renamed_recast as (
    select
        promo_id as promo_guid
        , discount
        , status
    from source
)

select * from renamed_recast
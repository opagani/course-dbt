with source as (
    select * from {{ source('postgres', 'users')}}
)

, renamed_recast as (
    select
        -- ids
        user_id as users_guid
        , address_id as address_guid
        -- timestamps
        , created_at as created_at_utc
        , updated_at as updated_at_utc
        -- users
        , first_name
        , last_name
        , phone_number
        , email
    from source
)

select * from renamed_recast
{% snapshot products_snapshot %}

{{
  config(
    target_database = target.database,
    target_schema = target.schema,
    strategy='check',
    unique_key='product_guid',
    check_cols=['inventory'],
   )
}}

with base as (
    select * from {{ ref('stg_postgres__products') }}
)

select * from base

{% endsnapshot %}
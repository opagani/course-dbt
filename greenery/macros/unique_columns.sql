{% macro get_column_values(table_name, column_name) %}

{% set event_types = dbt_utils.get_column_values(table=ref('stg_postgres__events'), column='event_type') %}

{% endmacro %}
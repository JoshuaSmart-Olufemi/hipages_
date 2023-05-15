{% macro as_timestamp_utc(column_name) %}

    cast({{ column_name }} as timestamp(0))

{% endmacro %}
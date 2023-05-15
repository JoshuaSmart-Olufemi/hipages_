{% macro as_timestamp_utc(column_name) %}

    cast({{ column_name }} as time(0))

{% endmacro %}
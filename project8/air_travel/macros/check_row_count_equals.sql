{% test check_row_count_equals(model, raw_table) %}
        select
            row_count
        from (
            select
                count(*) AS row_count
            from {{ model }}
        )
        where row_count <> ( select count(*) from {{ raw_table }} )
{% endtest %}
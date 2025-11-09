
        select
            row_count
        from (
            select
                count(*) AS row_count
            from `cs378-fa2025`.`dbt_air_travel_stg`.`countries`
        )
        where row_count <> ( select count(*) from `cs378-fa2025`.`air_travel_raw`.`countries` )

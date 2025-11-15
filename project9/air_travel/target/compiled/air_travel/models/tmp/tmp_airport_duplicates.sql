with tmp_airport_duplicates as (
    select * 
    from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_all`
    where icao in
        (select icao
        from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_all`
        group by icao
        having count(*) > 1)
)

select * from tmp_airport_duplicates
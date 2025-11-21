





with validation_errors as (

    select
        airline_id, source_airport_icao, dest_airport_icao
    from `cs378-fa2025`.`dbt_air_travel_int`.`Flight_Routes`
    group by airline_id, source_airport_icao, dest_airport_icao
    having count(*) > 1

)

select *
from validation_errors









with validation_errors as (

    select
        icao, iata, name
    from `cs378-fa2025`.`dbt_air_travel_int`.`Aircraft`
    group by icao, iata, name
    having count(*) > 1

)

select *
from validation_errors



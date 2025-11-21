





with validation_errors as (

    select
        airport_icao, terminal, business, location
    from `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Concessions`
    group by airport_icao, terminal, business, location
    having count(*) > 1

)

select *
from validation_errors



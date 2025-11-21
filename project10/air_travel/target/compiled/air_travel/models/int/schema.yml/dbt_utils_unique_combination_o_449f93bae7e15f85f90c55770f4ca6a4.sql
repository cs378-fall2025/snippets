





with validation_errors as (

    select
        event_month, airline_id, airport_icao
    from `cs378-fa2025`.`dbt_air_travel_int`.`Flight_Delays`
    group by event_month, airline_id, airport_icao
    having count(*) > 1

)

select *
from validation_errors



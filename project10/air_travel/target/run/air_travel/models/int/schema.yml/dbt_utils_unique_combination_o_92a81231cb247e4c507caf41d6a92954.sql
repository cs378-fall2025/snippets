
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        airline_id, source_airport_icao, dest_airport_icao, icao_equipment
    from `cs378-fa2025`.`dbt_air_travel_int`.`Route_Equipment`
    group by airline_id, source_airport_icao, dest_airport_icao, icao_equipment
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test
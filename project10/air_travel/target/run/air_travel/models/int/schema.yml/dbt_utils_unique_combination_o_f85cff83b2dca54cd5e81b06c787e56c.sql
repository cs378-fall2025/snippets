
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        icao, iata, name
    from `cs378-fa2025`.`dbt_air_travel_int`.`Aircraft`
    group by icao, iata, name
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test

    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        airport_icao, terminal, business, location
    from `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Concessions`
    group by airport_icao, terminal, business, location
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test

    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        event_date, event_hour, airport_icao, security_checkpoint
    from `cs378-fa2025`.`dbt_air_travel_int`.`TSA_Traffic`
    group by event_date, event_hour, airport_icao, security_checkpoint
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test
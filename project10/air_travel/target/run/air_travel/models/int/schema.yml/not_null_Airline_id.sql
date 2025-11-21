
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select id
from `cs378-fa2025`.`dbt_air_travel_int`.`Airline`
where id is null



  
  
      
    ) dbt_internal_test
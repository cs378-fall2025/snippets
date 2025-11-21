
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select business
from `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Establishment`
where business is null



  
  
      
    ) dbt_internal_test
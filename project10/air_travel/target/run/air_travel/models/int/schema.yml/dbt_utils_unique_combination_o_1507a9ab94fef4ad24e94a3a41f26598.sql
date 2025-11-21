
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        business, menu_item
    from `cs378-fa2025`.`dbt_air_travel_int`.`Food_Beverage`
    group by business, menu_item
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test
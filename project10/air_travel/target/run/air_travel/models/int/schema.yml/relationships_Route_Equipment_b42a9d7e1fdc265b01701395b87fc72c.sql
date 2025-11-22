
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select dest_airport_icao as from_field
    from `cs378-fa2025`.`dbt_air_travel_int`.`Route_Equipment`
    where dest_airport_icao is not null
),

parent as (
    select icao as to_field
    from `cs378-fa2025`.`dbt_air_travel_int`.`Airport`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test

    
    

with dbt_test__target as (

  select iso_code as unique_field
  from `cs378-fa2025`.`dbt_air_travel_int`.`Country`
  where iso_code is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1



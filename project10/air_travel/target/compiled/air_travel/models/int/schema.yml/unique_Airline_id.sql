
    
    

with dbt_test__target as (

  select id as unique_field
  from `cs378-fa2025`.`dbt_air_travel_int`.`Airline`
  where id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1



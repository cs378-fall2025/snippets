
    
    

with child as (
    select country_code as from_field
    from `cs378-fa2025`.`dbt_air_travel_int`.`Airline`
    where country_code is not null
),

parent as (
    select iso_code as to_field
    from `cs378-fa2025`.`dbt_air_travel_int`.`Country`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



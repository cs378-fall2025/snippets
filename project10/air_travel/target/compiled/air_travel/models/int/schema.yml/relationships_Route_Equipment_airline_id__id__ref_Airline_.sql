
    
    

with child as (
    select airline_id as from_field
    from `cs378-fa2025`.`dbt_air_travel_int`.`Route_Equipment`
    where airline_id is not null
),

parent as (
    select id as to_field
    from `cs378-fa2025`.`dbt_air_travel_int`.`Airline`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null




    
    

with child as (
    select business as from_field
    from `cs378-fa2025`.`dbt_air_travel_int`.`Food_Beverage`
    where business is not null
),

parent as (
    select business as to_field
    from `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Establishment`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



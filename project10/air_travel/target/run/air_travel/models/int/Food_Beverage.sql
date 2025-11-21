
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_int`.`Food_Beverage`
      
    
    

    
    OPTIONS()
    as (
      with Food_Beverage as (
  select distinct business, menu_item
  from
    (select e.business, split(m.menu_items, ',') as menu_items
    from `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Establishment` e join `cs378-fa2025`.`dbt_air_travel_stg`.`airport_maps` m
    on e.business = m.business
    where e.dining = True) t, unnest(t.menu_items) as menu_item
  order by business
)

select * 
from Food_Beverage
    );
  
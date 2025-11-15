with Food_Beverage as (
  select distinct business, menu_item
  from
    (select e.business, split(m.menu_items, ',') as menu_items
    from {{ ref('Airport_Establishment') }} e join {{ ref('airport_maps') }} m
    on e.business = m.business
    where e.dining = True) t, unnest(t.menu_items) as menu_item
  order by business
)

select * 
from Food_Beverage
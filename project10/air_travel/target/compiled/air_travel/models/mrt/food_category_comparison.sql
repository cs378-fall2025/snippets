with lax_categories as (
  select sub_category, count(*) as lax_availability_count
  from `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Establishment` e
  join `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Concessions` c
  on e.business = c.business
  where e.dining = True
  and c.airport_icao = 'KLAX'
  group by sub_category
  order by sub_category
),
reviews_categories as (
  select category, count(*) as num_mentions
  from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_terminal_food_keywords_category`
  where category != 'None'
  group by category
  order by category
)

select r.category, r.num_mentions, l.lax_availability_count
from reviews_categories r join lax_categories l
on r.category = l.sub_category
order by r.category
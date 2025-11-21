with tmp_airport_establishment_unique as (
  select distinct business, category, dining, _data_source, _load_time
  from `cs378-fa2025`.`dbt_air_travel_stg`.`airport_maps`
  order by category, business
)
select * 
from tmp_airport_establishment_unique
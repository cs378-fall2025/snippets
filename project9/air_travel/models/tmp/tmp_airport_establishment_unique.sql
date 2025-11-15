with tmp_airport_establishment_unique as (
  select distinct business, category, dining, _data_source, _load_time
  from {{ ref('airport_maps') }}
  order by category, business
)
select * 
from tmp_airport_establishment_unique
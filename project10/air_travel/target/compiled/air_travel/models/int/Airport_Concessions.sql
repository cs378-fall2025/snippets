with Airport_Concessions as (
  select distinct a.icao as airport_icao, m.terminal, m.business, m.location, m._data_source, m._load_time
  from `cs378-fa2025`.`dbt_air_travel_stg`.`airport_maps` m join `cs378-fa2025`.`dbt_air_travel_int`.`Airport` a
  on upper(m.airport) = a.iata
  where a.country_code = 'US'
  and m.business in
    (select business from `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Establishment`)
  order by m.business
)

select * 
from Airport_Concessions
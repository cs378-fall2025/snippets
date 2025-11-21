with Airport as (
  select a.icao, a.iata, a.name, a.city, a.state_prov, c.iso_code as country_code,
    a.latitude, a.longitude, a.timezone_delta, a.daylight_savings_time, a.timezone_name,
    a.type, a.source, a._data_source, a._load_time
  from {{ ref('tmp_airport_refined') }} a join {{ ref('Country') }} c
  on a.country = c.name
  where c.iso_code is not null
  union all
  select a.icao, a.iata, a.name, a.city, a.state_prov, c.mapped_iso_code as country_code,
    a.latitude, a.longitude, a.timezone_delta, a.daylight_savings_time, a.timezone_name,
    a.type, a.source, a._data_source, a._load_time
  from {{ ref('tmp_airport_refined') }} a join {{ ref('tmp_airport_country_closest_match') }} c
  on a.country = c.airport_country_name
  where c.mapped_iso_code is not null
)

select distinct * 
from Airport
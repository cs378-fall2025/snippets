with Airport as (
  select a.icao, a.iata, a.name, a.city, a.state_prov, c.iso_code as country_code,
    a.latitude, a.longitude, a.timezone_delta, a.daylight_savings_time, a.timezone_name,
    a.type, a.source, a._data_source, a._load_time
  from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_refined` a join `cs378-fa2025`.`dbt_air_travel_int`.`Country` c
  on a.country = c.name
  where c.iso_code is not null
  union all
  select a.icao, a.iata, a.name, a.city, a.state_prov, c.mapped_iso_code as country_code,
    a.latitude, a.longitude, a.timezone_delta, a.daylight_savings_time, a.timezone_name,
    a.type, a.source, a._data_source, a._load_time
  from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_refined` a join `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_country_iso_codes` c
  on a.country = c.airport_country_name
  where c.mapped_iso_code is not null
)

select distinct * 
from Airport
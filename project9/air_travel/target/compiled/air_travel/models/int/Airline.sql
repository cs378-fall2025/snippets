with airline_country_joined as (
  select a.id, a.name, a.alias, a.icao, a.iata, a.callsign, 
    a.country as country_name, c.iso_code as country_code, a.active, 
    a._data_source, a._load_time
  from `cs378-fa2025`.`dbt_air_travel_stg`.`airlines` a left join `cs378-fa2025`.`dbt_air_travel_int`.`Country` c
  on a.country = c.name
  where c.iso_code is not null 
),
Airline as (
    select acj.id, acj.name, acj.alias, acj.icao, acj.iata, acj.callsign, 
        acj.country_name, amc.mapped_iso_code as country_code, 
        acj.active, acj._data_source, acj._load_time 
    from airline_country_joined acj join `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airline_country_mapped` amc
    on acj.country_name = amc.original_country
    where acj.country_code is null
    and acj.country_name is not null
)

select *
from Airline
with airline_country_joined as (
  select a.id, a.name, a.alias, a.icao, a.iata, a.callsign, 
    c.iso_code as country_code, a.active, 
    a._data_source, a._load_time
  from {{ ref('airlines') }} a join {{ ref('Country') }} c
  on a.country = c.name
  where c.iso_code is not null 
),
airline_country_fuzzy_matches as (
  select a.id, a.name, a.alias, a.icao, a.iata, a.callsign, 
    c.iso_code as country_code, a.active, 
    a._data_source, a._load_time
  from {{ ref('airlines') }} a join {{ ref('tmp_airline_country_mapped') }} amc
  on a.country = amc.original_country
  join {{ ref('Country') }} c
  on amc.mapped_iso_code = c.iso_code
  where c.iso_code is not null
)

select *
from airline_country_joined
union distinct
select * 
from airline_country_fuzzy_matches


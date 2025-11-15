with Airport_Concessions as (
  select distinct a.icao as airport_icao, m.terminal, m.business, m.location, m._data_source, m._load_time
  from {{ ref('airport_maps') }} m join {{ ref('Airport') }} a
  on upper(m.airport) = a.iata
  where a.country_code = 'US'
  and m.business not in
    (select business from {{ ref('Airport_Establishment') }})
  order by m.business
)

select * 
from Airport_Concessions
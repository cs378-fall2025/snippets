with Flight_Routes as (
  select distinct r.airline_id, a1.icao as source_airport_icao, 
    a2.icao as dest_airport_icao, r.codeshare, r.stops, r.equipment, 
    r._data_source, r._load_time
  from {{ ref('flight_routes') }} r
  join {{ ref('Airport') }} a1
  on r.source_airport = a1.iata
  join {{ ref('Airport') }} a2
  on r.dest_airport = a2.iata
)

select * 
from Flight_Routes
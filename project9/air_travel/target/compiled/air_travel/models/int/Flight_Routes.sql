with Flight_Routes as (
  select distinct r.airline_id, a1.icao as source_airport_icao, 
    a2.icao as dest_airport_icao, r.codeshare, r.stops, r.equipment, 
    r._data_source, r._load_time
  from `cs378-fa2025`.`dbt_air_travel_stg`.`flight_routes` r
  join `cs378-fa2025`.`dbt_air_travel_int`.`Airport` a1
  on r.source_airport = a1.iata
  join `cs378-fa2025`.`dbt_air_travel_int`.`Airport` a2
  on r.dest_airport = a2.iata
)

select * 
from Flight_Routes
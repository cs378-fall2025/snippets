with delayed_flights as (
    select ac.name as aircraft, ac.icao as aircraft_code, 
        count(*) aircraft_delay_flights
    from {{ ref('Flight_Delays') }} fd
    join {{ ref('Airline') }} al
        on fd.airline_id = al.id
    join {{ ref('Airport') }} ap
        on fd.airport_icao = ap.icao
    join {{ ref('Route_Equipment') }} re
        on al.id = re.airline_id and ap.icao = re.dest_airport_icao
    join {{ ref('Aircraft') }} ac
        on re.icao_equipment = ac.icao
    where carrier_delay_min > 0
    and weather_delay_min = 0
    group by ac.name, ac.icao
    order by ac.name
),
total_flights as (
    select ac.name as aircraft, ac.icao as aircraft_code, count(*) aircraft_total_flights
    from {{ ref('Flight_Delays') }} fd
    join {{ ref('Airline') }} al
    on fd.airline_id = al.id
    join {{ ref('Airport') }} ap
    on fd.airport_icao = ap.icao
    join {{ ref('Route_Equipment') }} re
    on al.id = re.airline_id and ap.icao = re.dest_airport_icao
    join {{ ref('Aircraft') }} ac
    on re.icao_equipment = ac.icao
    group by ac.name, ac.icao
    order by ac.name
)

select aircraft, aircraft_code, aircraft_delay_flights, aircraft_total_flights, round(aircraft_delay_flights / aircraft_total_flights * 100) as aircraft_delay_rate
from delayed_flights
join total_flights
using (aircraft, aircraft_code)
order by aircraft_delay_rate desc
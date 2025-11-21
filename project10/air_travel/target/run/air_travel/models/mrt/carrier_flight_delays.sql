
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_mrt`.`carrier_flight_delays`
      
    
    

    
    OPTIONS()
    as (
      with delayed_flights as (
    select ap.state_prov, ap.icao, ap.name as airport, al.name as airline,
        count(fd.carrier_delay_min) carrier_delay_count
    from `cs378-fa2025`.`dbt_air_travel_int`.`Flight_Delays` fd
    join `cs378-fa2025`.`dbt_air_travel_int`.`Airline` al
        on fd.airline_id = al.id
    join `cs378-fa2025`.`dbt_air_travel_int`.`Airport` ap
        on fd.airport_icao = ap.icao
    where carrier_delay_min > 0
    and weather_delay_min = 0
    group by ap.state_prov, ap.icao, ap.name, al.name
    order by ap.state_prov, al.name
),
all_flights as (
    select ap.state_prov, ap.icao, ap.name as airport, al.name as airline,
        count(*) as total_flights
    from `cs378-fa2025`.`dbt_air_travel_int`.`Flight_Delays` fd
    join `cs378-fa2025`.`dbt_air_travel_int`.`Airline` al
        on fd.airline_id = al.id
    join `cs378-fa2025`.`dbt_air_travel_int`.`Airport` ap
        on fd.airport_icao = ap.icao
    group by ap.state_prov, ap.icao, ap.name, al.name
    order by ap.state_prov, al.name
)

select state_prov, icao, airport, airline, carrier_delay_count, total_flights,
  round(carrier_delay_count / total_flights * 100) as delay_rate_percent
from delayed_flights join all_flights
using (state_prov, icao, airport, airline)
order by delay_rate_percent desc
    );
  
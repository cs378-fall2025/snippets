
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_mrt`.`aircraft_flight_delays`
      
    
    

    
    OPTIONS()
    as (
      with delayed_flights as (
    select ac.name as aircraft, ac.icao as aircraft_code, 
        count(*) aircraft_delay_flights
    from `cs378-fa2025`.`dbt_air_travel_int`.`Flight_Delays` fd
    join `cs378-fa2025`.`dbt_air_travel_int`.`Airline` al
        on fd.airline_id = al.id
    join `cs378-fa2025`.`dbt_air_travel_int`.`Airport` ap
        on fd.airport_icao = ap.icao
    join `cs378-fa2025`.`dbt_air_travel_int`.`Route_Equipment` re
        on al.id = re.airline_id and ap.icao = re.dest_airport_icao
    join `cs378-fa2025`.`dbt_air_travel_int`.`Aircraft` ac
        on re.icao_equipment = ac.icao
    where carrier_delay_min > 0
    and weather_delay_min = 0
    group by ac.name, ac.icao
    order by ac.name
),
total_flights as (
    select ac.name as aircraft, ac.icao as aircraft_code, count(*) aircraft_total_flights
    from `cs378-fa2025`.`dbt_air_travel_int`.`Flight_Delays` fd
    join `cs378-fa2025`.`dbt_air_travel_int`.`Airline` al
    on fd.airline_id = al.id
    join `cs378-fa2025`.`dbt_air_travel_int`.`Airport` ap
    on fd.airport_icao = ap.icao
    join `cs378-fa2025`.`dbt_air_travel_int`.`Route_Equipment` re
    on al.id = re.airline_id and ap.icao = re.dest_airport_icao
    join `cs378-fa2025`.`dbt_air_travel_int`.`Aircraft` ac
    on re.icao_equipment = ac.icao
    group by ac.name, ac.icao
    order by ac.name
)

select aircraft, aircraft_code, aircraft_delay_flights, aircraft_total_flights, round(aircraft_delay_flights / aircraft_total_flights * 100) as aircraft_delay_rate
from delayed_flights
join total_flights
using (aircraft, aircraft_code)
order by aircraft_delay_rate desc
    );
  
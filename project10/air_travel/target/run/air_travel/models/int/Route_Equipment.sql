
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_int`.`Route_Equipment`
      
    
    

    
    OPTIONS()
    as (
      with Route_Equipment as (
    select airline_id, source_airport_icao, dest_airport_icao, equipment, _data_source, _load_time
    from (
        select airline_id, source_airport_icao, dest_airport_icao, split(trim(equipment), ' ') as equipment_array,
            _data_source, _load_time
        from `cs378-fa2025`.`dbt_air_travel_int`.`Flight_Routes`
        where equipment is not null) r, unnest(r.equipment_array) as equipment
)

select distinct re.airline_id, re.source_airport_icao, re.dest_airport_icao,
    a.icao as icao_equipment, re._data_source, re._load_time
from Route_Equipment re join `cs378-fa2025`.`dbt_air_travel_int`.`Aircraft` a
on re.equipment = a.iata
join `cs378-fa2025`.`dbt_air_travel_int`.`Airline` al 
on re.airline_id = al.id
    );
  
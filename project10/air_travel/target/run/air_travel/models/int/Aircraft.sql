
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_int`.`Aircraft`
      
    
    

    
    OPTIONS()
    as (
      with Aircraft as (
    select icao, iata, name, _data_source, _load_time
    from `cs378-fa2025`.`dbt_air_travel_stg`.`aircrafts`
    where icao is not null
    union all
    select i.aircraft_icao as icao, a.iata, a.name, a._data_source, a._load_time
    from `cs378-fa2025`.`dbt_air_travel_stg`.`aircrafts` a join `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_aircraft_icao` i
    on a.name = i.aircraft_name
    where a.icao is null
)

select *
from Aircraft
    );
  
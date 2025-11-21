
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_stg`.`airlines`
      
    
    

    
    OPTIONS()
    as (
      with stg_airlines as (
  select airline_id as id,
    name,
    case alias
        when '\\N' then null
        else alias
        end as alias,
    case iata
        when '' then null
        else iata
        end as iata,
    case icao
        when '' then null
        else icao
        end as icao,
    case callsign
        when '\\N' then null
        else callsign
        end as callsign,
    case country
        when '\\N' then null
        else country end as country,
    active, _data_source, _load_time
  from `cs378-fa2025`.`air_travel_raw`.`airlines`
)

select * from stg_airlines
    );
  
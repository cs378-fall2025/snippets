
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_stg`.`airports`
      
    
    

    
    OPTIONS()
    as (
      with stg_airports as (
	select safe_cast(airport_id as INTEGER) as id,
	    airport_name as name,
	    airport_city as city,
	    airport_country as country,
	    case iata
		    when '\\N' then null
		    else iata
		    end as iata,
	    case icao
		    when '\\N' then null
		    else icao
		    end as icao,
	    latitude,
	    longitude,
	    altitude,
	    safe_cast(timezone as INTEGER) as timezone_delta,
        daylight_savings_time,
        case tz_database_timezone
		    when '\\N' then null
		    else tz_database_timezone
		    end as timezone_name,
	    case type
		    when '\\N' then null
		    else type
		    end as type,
	    case source
		    when '\\N' then null
		    else source
		    end as source,
	    _data_source,
	    _load_time
	from `cs378-fa2025`.`air_travel_raw`.`airports`    
)

select * from stg_airports
    );
  
with tmp_airport_all as (
    select distinct al.llm_icao as icao, a.iata, a.name, a.city, al.llm_state_prov as state_prov, 
        a.country, a.latitude, a.longitude, a.timezone_delta, a.daylight_savings_time, 
        a.timezone_name, a.type, a.source, 'openflights,llm' as _data_source, a._load_time
    from `cs378-fa2025`.`dbt_air_travel_stg`.`airports` a join `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_llm` al
    on a.name = al.name and a.country = al.country
    where a.iata is not null
    and al.llm_icao is not null
)

select * from tmp_airport_all
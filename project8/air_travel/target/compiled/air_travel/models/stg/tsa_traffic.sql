with stg_tsa_traffic as (
  select safe_cast(event_date as DATE format 'MM/DD/YYYY') as event_date,
    safe_cast(event_hour as INTEGER) as event_hour,
    airport_code,
    airport_name,
    airport_city,
    airport_state,
    security_checkpoint,
    safe_cast(total_traffic as INTEGER) as total_traffic,
    _data_source,
    _load_time
  from `cs378-fa2025`.`air_travel_raw`.`tsa_traffic`
)

select * from stg_tsa_traffic
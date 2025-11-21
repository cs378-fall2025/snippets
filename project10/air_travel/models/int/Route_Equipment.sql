with Route_Equipment as (
    select airline_id, source_airport_icao, dest_airport_icao, equipment, _data_source, _load_time
    from (
        select airline_id, source_airport_icao, dest_airport_icao, split(trim(equipment), ' ') as equipment_array,
            _data_source, _load_time
        from {{ ref('Flight_Routes') }}
        where equipment is not null) r, unnest(r.equipment_array) as equipment
)

select distinct re.airline_id, re.source_airport_icao, re.dest_airport_icao,
    a.icao as icao_equipment, re._data_source, re._load_time
from Route_Equipment re join air_travel_int.Aircraft a
on re.equipment = a.iata

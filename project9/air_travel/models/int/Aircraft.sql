with Aircraft as (
    select icao, iata, name, _data_source, _load_time
    from {{ ref('aircrafts') }}
    where icao is not null
    union all
    select i.aircraft_icao as icao, a.iata, a.name, a._data_source, a._load_time
    from {{ ref('aircrafts') }} a join {{ ref('tmp_aircraft_icao') }} i
    on a.name = i.aircraft_name
    where a.icao is null
)

select *
from Aircraft
with TSA_Traffic as (
  select distinct t.event_date, t.event_hour, a.icao as airport_icao, 
    t.security_checkpoint, t.total_traffic, t._data_source, t._load_time
  from {{ ref('Airport') }} a join {{ ref('tsa_traffic') }} t
  on a.iata = t.airport_code
  and a.city = t.airport_city
  where a.country_code = 'US'
  and t.event_date is not null
  and t.event_hour is not null
  and a.icao is not null
  and t.security_checkpoint is not null
)

select * 
from TSA_Traffic
with passenger_sentiment_airports_top_kpis as (
  select r.sub_category, a.icao, a.name as airport, a.city, 
    a.state_prov, c.name as country, r.sentiment, count(*) as count
  from {{ ref('Airport_Review') }} r
  join {{ ref('Airport') }} a on r.airport_icao = a.icao
  join {{ ref('Country') }} c on a.country_code = c.iso_code
  where r.sub_category in ('Wayfinding & Information', 'Airport Staff',
    'Amenities & Facilities', 'Boarding Process', 'Security Screening',
    'Food, Beverage & Retail')
  group by r.sub_category, a.icao, a.name, a.city, a.state_prov, c.name, r.sentiment
  order by r.sub_category, count(*) desc, a.name
)

select *
from passenger_sentiment_airports_top_kpis


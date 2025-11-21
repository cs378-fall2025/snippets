with stg_airport_maps as (
  select airport, terminal, business,
      case category
        when 'Airline Services' then 'Airline Service'
        when 'Airline Services' then 'Airline Service'
        when 'Cafe' then 'Coffee Shop'
        when 'Financial Services' then 'Financial Service'
        when 'Retail/Dining' then 'Retail / Dining'
        when 'Things To Do' then 'Things to Do'
        when 'Transportation' then 'Transportation Service'
        when 'Vending' then 'Vending Machine'
        when 'Service' then 'Services'
        else category end as category,
      location, dining, menu_items, _data_source, _load_time
    from {{ source('air_travel_raw', 'airport_maps') }}
)

select * from stg_airport_maps
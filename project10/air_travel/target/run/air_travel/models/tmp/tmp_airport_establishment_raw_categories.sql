
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_establishment_raw_categories`
      
    
    

    
    OPTIONS()
    as (
      with airport_establishment_raw_categories as (
  select distinct business, category
  from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_establishment_unique`
  where category not in ('Airline', 'Airline Service', 'Airline Services', 'Airline Check-in', 'Airline Ticketing',
      'Airline Gate / Check-in', 'Airline Lounge', 'Airport Lounge', 'Airport Service', 'Airport Services', 'Air Freight', 'Car Rental',
      'Information Kiosk', 'Information Service', 'Parking', 'Transportation Service')
)

select * 
from airport_establishment_raw_categories
    );
  
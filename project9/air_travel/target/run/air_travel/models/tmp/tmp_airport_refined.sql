
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_refined`
      
    
    

    
    OPTIONS()
    as (
      with tmp_airport_refined as (
    select *
    from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_all`
    where icao not in (select distinct icao from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_duplicates`)
    union all
    select * from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_duplicates`
    where concat(icao, ',', iata, ',', name) in
      (select concat(base_icao, ',', base_iata, ',', base_name)
       from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_vector_search_results`
       where distance < 0.08)
)

select * from tmp_airport_refined
    );
  
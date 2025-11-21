
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_mrt`.`foot_traffic_starbucks_terminals_monthly`
      
    
    

    
    OPTIONS()
    as (
      with foot_traffic_starbucks_terminals_monthly as (
  select case month_of_year
    when 1 then 'January'
    when 2 then 'February'
    when 3 then 'March'
    when 4 then 'April'
    when 5 then 'May'
    when 6 then 'June'
    when 7 then 'July'
    when 8 then 'August'
    when 9 then 'September'
    when 10 then 'October'
    when 11 then 'November'
    when 12 then 'December' end as month_long, * except (month_of_year)
  from
    (select extract(month from t.event_date) as month_of_year, 
      ct.mapped_terminal as terminal, t.airport_icao, a.name as airport,
      ac.location, round(avg(total_traffic), 2) avg_foot_traffic
    from `cs378-fa2025`.`dbt_air_travel_int`.`TSA_Traffic` t
    join `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_tsa_checkpoint_terminal` ct
      on t.airport_icao = ct.airport_icao and t.security_checkpoint = ct.security_checkpoint
    join `cs378-fa2025`.`dbt_air_travel_int`.`Airport` a on t.airport_icao = a.icao
    join `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Concessions` ac on a.icao = ac.airport_icao
    join `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Concessions` ac2
      on ac2.airport_icao = ct.airport_icao and ac2.terminal = ct.mapped_terminal
    where ac.business = 'Starbucks'
    group by extract(month from t.event_date), ct.mapped_terminal, t.airport_icao, a.name, ac.location
    order by airport_icao, month_of_year)
)

select *
from foot_traffic_starbucks_terminals_monthly
    );
  
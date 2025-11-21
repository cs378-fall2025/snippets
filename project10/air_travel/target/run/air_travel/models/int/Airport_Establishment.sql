
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Establishment`
      
    
    

    
    OPTIONS()
    as (
      with airport_establishment_joined as (
  select distinct e.business, m.broad_category, m.sub_category,
    case when m.broad_category in ('Fast Casual', 'Full-Service Dining') then True else False end as dining,
    'airport.guide,llm' as _data_source, e._load_time
  from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_establishment_unique` e 
  join `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_establishment_sub_categories_mapped` m
  on e.business = m.business
),
Airport_Establishment as (
  select *, rank() over (
      partition by business
      order by 
        (select count 
        from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_establishment_broad_categories_frequency` 
        where broad_category = ae.broad_category)
  ) as business_rank
  from airport_establishment_joined ae
)

select * except(business_rank)
from Airport_Establishment
where business_rank = 1
    );
  
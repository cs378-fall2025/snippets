with Airport_Establishment as
(
  select distinct e.business, m.broad_category, m.sub_category,
    case when m.broad_category in ('Fast Casual', 'Full-Service Dining') then True else False end as dining,
    'airport.guide,llm' as _data_source, e._load_time
  from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_establishment_unique` e 
  join `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_establishment_sub_categories_mapped` m
  on e.business = m.business
)

select * from Airport_Establishment
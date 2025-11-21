with broad_categories_frequency as (
    select broad_category, count(*) as count
    from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_establishment_broad_categories_mapped`
    group by broad_category
    order by count desc
)

select *
from broad_categories_frequency
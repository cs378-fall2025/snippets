with broad_categories_frequency as (
    select broad_category, count(*) as count
    from {{ ref('tmp_airport_establishment_broad_categories_mapped') }}
    group by broad_category
    order by count desc
)

select *
from broad_categories_frequency

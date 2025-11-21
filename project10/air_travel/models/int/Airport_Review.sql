with Airport_Review as (
    select distinct r.id, r.review_thread, r.review_date, r.review_author,
      r.review_subject, r.review_details, a.icao as airport_icao, r.broad_category, r.sub_category, r.sentiment,
      r.language, r._data_source, r._load_time
    from {{ ref('airport_reviews') }} r join {{ ref('Airport') }} a
    on a.icao = r.airport_code
)

select * 
from Airport_Review
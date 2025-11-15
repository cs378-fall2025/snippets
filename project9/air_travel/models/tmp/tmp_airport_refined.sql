with tmp_airport_refined as (
    select *
    from {{ ref('tmp_airport_all') }}
    where icao not in (select distinct icao from {{ ref('tmp_airport_duplicates') }})
    union all
    select * from {{ ref('tmp_airport_duplicates') }}
    where concat(icao, ',', iata, ',', name) in
      (select concat(base_icao, ',', base_iata, ',', base_name)
       from {{ ref('tmp_airport_vector_search_results') }}
       where distance < 0.08)
)

select * from tmp_airport_refined
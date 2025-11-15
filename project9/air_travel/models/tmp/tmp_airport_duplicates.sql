with tmp_airport_duplicates as (
    select * 
    from {{ ref('tmp_airport_all') }}
    where icao in
        (select icao
        from {{ ref('tmp_airport_all') }}
        group by icao
        having count(*) > 1)
)

select * from tmp_airport_duplicates
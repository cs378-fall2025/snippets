
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_stg`.`airport_reviews`
      
    
    

    
    OPTIONS()
    as (
      with stg_airport_reviews as (
	select id,
	    safe_cast(threadRef as INTEGER) as review_thread,
	    airportRef as airport_id,
	    airportIdent as airport_code,
	    safe_cast(split(date, ' ')[0] as DATE) as review_date,
	    memberNickname as review_author,
	    subject as review_subject,
	    body as review_details,
	    broad_category,
        sub_category,
        sentiment,
        language,
	    _data_source,
	    _load_time
	from `cs378-fa2025`.`air_travel_raw`.`airport_reviews`
)

select * from stg_airport_reviews
    );
  
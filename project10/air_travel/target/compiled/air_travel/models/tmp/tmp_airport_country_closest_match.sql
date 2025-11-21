with unmatched_country_codes as (
    select airport_country_name, mapped_iso_code 
    from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_country_iso_codes`
    where airport_country_name not in 
        (select name from `cs378-fa2025`.`dbt_air_travel_int`.`Country` )
),
find_closest_match as (
    select u.airport_country_name, u.mapped_iso_code as original_iso_code, 
      AI.GENERATE(
      ('What is the closest match for country ', airport_country_name, 'with iso code ', mapped_iso_code, ' from the reference list below? Return the most suitable matching iso that appears in parenthesis. If there is no suitable match, return None', array_to_string(array_agg(concat(c.name, ' (', c.iso_code, ')')), ', ')),
      connection_id => 'us-central1.vertex-ai-connection',
      endpoint => 'gemini-2.5-flash-lite',
      model_params => JSON '{"generation_config":{"thinking_config": {"thinking_budget": 0}}, "tools": [{"googleSearch": {}}]}',
      output_schema => 'iso_code STRING') as llm_response
    from unmatched_country_codes u cross join `cs378-fa2025`.`dbt_air_travel_int`.`Country` c
    group by u.airport_country_name, u.mapped_iso_code
)

select airport_country_name, original_iso_code, 
  llm_response.iso_code as mapped_iso_code
from find_closest_match
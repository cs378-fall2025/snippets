

with tmp_country_iso_codes as (
    select
      name,
      AI.GENERATE(
        ('What is the iso code for country ', name, '? If it does not have one, return None.'),
        connection_id => 'us-central1.vertex-ai-connection',
        endpoint => 'gemini-2.5-flash-lite',
        model_params => JSON '{"generation_config":{"thinking_config": {"thinking_budget": 0}}, "tools": [{"googleSearch": {}}]}',
        output_schema => 'iso_code STRING') as llm_response
    from `cs378-fa2025`.`dbt_air_travel_stg`.`countries`
    where iso_code is null
  )
select name, llm_response.iso_code as mapped_iso_code
from tmp_country_iso_codes
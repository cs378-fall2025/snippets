

with airline_orphan_countries as (
    select distinct country
    from `cs378-fa2025`.`dbt_air_travel_stg`.`airlines`
    where country not in (select name from `cs378-fa2025`.`dbt_air_travel_int`.`Country`)
),
tmp_airline_countries_mapped as (
    select
      country,
      AI.GENERATE(
        ('If ', country, ' is a recognized country, return its iso code. If it is not a recognized country, return None.'),
        connection_id => 'us-central1.vertex-ai-connection',
        endpoint => 'gemini-2.5-flash-lite',
        model_params => JSON '{"generation_config":{"thinking_config": {"thinking_budget": 0}}, "tools": [{"googleSearch": {}}]}',
        output_schema => 'iso_code STRING') as llm_response
    from airline_orphan_countries
  )
  select country as original_country, llm_response.iso_code as mapped_iso_code
  from tmp_airline_countries_mapped
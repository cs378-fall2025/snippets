{{ config(tags=["llm"]) }}

with tmp_orphan_country as (
    select distinct country as airport_country_name
    from {{ ref('tmp_airport_refined') }}
    where country not in (select name from {{ ref('Country') }})
),
tmp_airport_country_iso_codes as (
    select airport_country_name,
      AI.GENERATE(
        ('What is the iso code for the country ', airport_country_name, '? If it does not have an iso code, return None.'),
        connection_id => 'us-central1.vertex-ai-connection',
        endpoint => 'gemini-2.5-flash-lite',
        model_params => JSON '{"generation_config":{"thinking_config": {"thinking_budget": 0}}, "tools": [{"googleSearch": {}}]}',
        output_schema => 'iso_code STRING') as llm_response
    from tmp_orphan_country
)
select airport_country_name, llm_response.iso_code as mapped_iso_code
from tmp_airport_country_iso_codes
with tmp_aircraft_icao as (
    select
      name as aircraft_name,
      AI.GENERATE(
        ('What is the icao code of aircraft ', name, '? If it does not have one, return None.'),
        connection_id => 'us-central1.vertex-ai-connection',
        endpoint => 'gemini-2.5-flash-lite',
        model_params => JSON '{"generation_config":{"thinking_config": {"thinking_budget": 0}}, "tools": [{"googleSearch": {}}]}',
        output_schema => 'aircraft_icao STRING') as llm_response
    from {{ ref('aircrafts') }}
    where icao is null
  )
select aircraft_name, llm_response.aircraft_icao
from tmp_aircraft_icao
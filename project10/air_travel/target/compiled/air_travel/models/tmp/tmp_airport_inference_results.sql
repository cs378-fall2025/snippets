

with tmp_airport_inference_results as (
    select icao,
      AI.GENERATE(
        ('What are the iata code and name of the airport that has the icao code of ', icao, '?'),
        connection_id => 'us-central1.vertex-ai-connection',
        endpoint => 'gemini-2.5-flash-lite',
        model_params => JSON '{"generation_config":{"thinking_config": {"thinking_budget": 0}}, "tools": [{"googleSearch": {}}]}',
        output_schema => 'iata STRING, name STRING') as llm_response
    from (select distinct icao from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_duplicates`)
)
select icao, llm_response.iata as iata, llm_response.name as name
from tmp_airport_inference_results
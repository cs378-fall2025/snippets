
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airports_llm`
      
    
    

    
    OPTIONS()
    as (
      with tmp_airports_llm as (
    select
      name,
      country,
      iata,
      AI.GENERATE(
        ('What are the icao code and state/province for airport ', name, ' in country ', country, ' which has an iata code of ', iata, '?'),
        connection_id => 'us-central1.vertex-ai-connection',
        endpoint => 'gemini-2.5-flash-lite',
        model_params => JSON '{"generation_config":{"thinking_config": {"thinking_budget": 0}}, "tools": [{"googleSearch": {}}]}',
        output_schema => 'icao STRING, state_prov STRING') as llm_response
    from `cs378-fa2025`.`dbt_air_travel_stg`.`airports`
    where iata is not null
  )
select name, country, iata, llm_response.icao as llm_icao, llm_response.state_prov as llm_state_prov
from tmp_airports_llm
    );
  
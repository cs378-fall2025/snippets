
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_tsa_checkpoint_terminal`
      
    
    

    
    OPTIONS()
    as (
      

with tsa_checkpoints as (
  select distinct security_checkpoint, airport_icao
  from `cs378-fa2025`.`dbt_air_travel_int`.`TSA_Traffic`
),
tmp_tsa_checkpoint_terminal as (
    select airport_icao, security_checkpoint,
    AI.GENERATE(
      ('What is the terminal for TSA security checkpoint ', security_checkpoint, ' and airport ', airport_icao, '? If you cannot find it, return None.'),
      connection_id => 'us-central1.vertex-ai-connection',
      endpoint => 'gemini-2.5-flash-lite',
      model_params => JSON '{"generation_config":{"thinking_config": {"thinking_budget": 0}}, "tools": [{"googleSearch": {}}]}',
      output_schema => 'terminal STRING') as llm_response
  from tsa_checkpoints
)

select airport_icao, security_checkpoint, llm_response.terminal as mapped_terminal
from tmp_tsa_checkpoint_terminal
    );
  
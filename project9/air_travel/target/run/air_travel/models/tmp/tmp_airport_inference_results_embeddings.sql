
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_inference_results_embeddings`
      
    
    

    
    OPTIONS()
    as (
      with tmp_airport_inference_results_embeddings as (
  select icao, iata, name, ml_generate_embedding_result as embedding
  from
    ML.GENERATE_EMBEDDING(
      model air_travel_model.embedding_model,
      (select icao, iata, name, concat(icao, ',', iata, ',', name) as content
       from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_inference_results`
       where iata is not null
       and name != 'Unknown'),
       struct(true as flatten_json_output, 'SEMANTIC_SIMILARITY' as task_type)
    )
)

select * from tmp_airport_inference_results_embeddings
    );
  
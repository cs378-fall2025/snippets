  {{ config(tags=["llm"]) }}
  
  with tmp_airport_duplicates_embeddings as (
      select icao, iata, name, ml_generate_embedding_result as embedding
      from
      ML.GENERATE_EMBEDDING(
        model air_travel_model.embedding_model,
        (select icao, iata, name, concat(icao, ',', iata, ',', name) as content
        from {{ ref('tmp_airport_duplicates') }}),
        struct(true as flatten_json_output, 'SEMANTIC_SIMILARITY' as task_type)
      )
  )

  select * from tmp_airport_duplicates_embeddings

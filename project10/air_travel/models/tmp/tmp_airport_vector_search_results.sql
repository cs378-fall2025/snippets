{{ config(tags=["llm"]) }}

with tmp_airport_vector_search_results as (
  select base.icao as base_icao, base.iata as base_iata, base.name as base_name,
    query.icao as query_icao, query.iata as query_iata, query.name as query_name,
    distance
  from
    vector_search(
      table {{ ref('tmp_airport_duplicates_embeddings') }}, -- this is the base (i.e what's in the Airport table)
      'embedding',
      table {{ ref('tmp_airport_inference_results_embeddings') }}, -- this is the query (i.e. results from LLM inference)
      'embedding',
      top_k => 1,
      distance_type => 'COSINE')
  where query.icao = base.icao
  order by distance
)

select * 
from tmp_airport_vector_search_results
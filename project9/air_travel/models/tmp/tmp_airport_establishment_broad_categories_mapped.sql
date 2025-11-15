{{ config(tags=["llm"]) }}

with canonical_categories as (
    select ARRAY_AGG(distinct broad_category) AS broad_categories
    from {{ ref('tmp_airport_establishment_canonical_categories') }}
),
tmp_airport_establishment_broad_categories_mapped as (
    select
      business,
      category as raw_category,
      AI.GENERATE(
        ('Map the business ', business, ' to its most fitting broad category from this canonical category list:',
          broad_categories),
        connection_id => 'us-central1.vertex-ai-connection',
        endpoint => 'gemini-2.5-flash-lite',
        model_params => JSON '{"generation_config":{"thinking_config": {"thinking_budget": 0}}, "tools": [{"googleSearch": {}}]}',
        output_schema => 'broad_category STRING') as llm_response
    from {{ ref('tmp_airport_establishment_raw_categories') }}
    cross join canonical_categories
  )
select business, raw_category, llm_response.broad_category as broad_category
from tmp_airport_establishment_broad_categories_mapped

  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_establishment_sub_categories_mapped`
      
    
    

    
    OPTIONS()
    as (
      with tmp_establishment_categories as (
    select m.business, m.broad_category,
      array_agg(distinct c.sub_category) AS sub_categories
    from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_establishment_broad_categories_mapped` m
    join `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_establishment_canonical_categories` c
    on m.broad_category = c.broad_category
    where m.broad_category is not null
    group by m.business, m.broad_category
),
tmp_airport_establishment_sub_categories_mapped as (
    select
      business,
      broad_category,
      AI.GENERATE(
        ('Map the airport concession ', business, ' with broad category ', broad_category,
        ' to its most fitting sub category based on this canonical list of subcategories: ', sub_categories),
        connection_id => 'us-central1.vertex-ai-connection',
        endpoint => 'gemini-2.5-flash-lite',
        model_params => JSON '{"generation_config":{"thinking_config": {"thinking_budget": 0}}, "tools": [{"googleSearch": {}}]}',
        output_schema => 'sub_category STRING') as llm_response
    from tmp_establishment_categories
  )
select business, broad_category, llm_response.sub_category as sub_category
from tmp_airport_establishment_sub_categories_mapped
    );
  
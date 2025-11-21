
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_terminal_food_keywords_category`
      
    
    

    
    OPTIONS()
    as (
      with canonical_food_categories as (
    select array_to_string(array_agg(distinct sub_category), ', ') as categories
    from `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Establishment`
    where dining = True
),
tmp_airport_terminal_food_keywords_category as (
    select review_id, review_content, keywords,
      AI.GENERATE(
        ('Map the food keywords , ', keywords, ' to its best fit category: ', categories,
          'If the keywords are too generic, return None.'),
        connection_id => 'us-central1.vertex-ai-connection',
        endpoint => 'gemini-2.5-flash-lite',
        model_params => JSON '{"generation_config":{"thinking_config": {"thinking_budget": 0}}, "tools": [{"googleSearch": {}}]}',
        output_schema => 'category STRING') as llm_response
     from `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_terminal_mentioned_food_keywords`
     cross join canonical_food_categories
     where keywords != 'None'
  )

select review_id, review_content, keywords, llm_response.category as category
from tmp_airport_terminal_food_keywords_category
    );
  
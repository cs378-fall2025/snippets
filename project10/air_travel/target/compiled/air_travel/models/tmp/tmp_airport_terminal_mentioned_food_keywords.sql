

with tmp_airport_terminal_mentioned_food_keywords as (
  select id as review_id, concat(review_subject, ':', review_details) as review_content,
  AI.GENERATE(
    ('If this review mentions food, what food keywords does it mention?',
      concat(review_subject, ':', review_details), '. Return your answer as a comma-separated list of keywords. If the review does not mention food, return None.'),
    connection_id => 'us-central1.vertex-ai-connection',
    endpoint => 'gemini-2.5-flash-lite',
    model_params => JSON '{"generation_config":{"thinking_config": {"thinking_budget": 0}}, "tools": [{"googleSearch": {}}]}',
    output_schema => 'keywords STRING') as llm_response
  from `cs378-fa2025`.`dbt_air_travel_int`.`Airport_Review`
  where sentiment != 'Negative'
)

select review_id, review_content, llm_response.keywords as keywords
from tmp_airport_terminal_mentioned_food_keywords
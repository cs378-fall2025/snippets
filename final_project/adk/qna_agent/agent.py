import time
import textwrap
import pandas
import logging
import os
import json
import altair
import proto

from io import BytesIO
from typing import Dict, Any
from dotenv import load_dotenv

import google.genai.types as types
from google.genai.types import ThinkingConfig
from google.genai.types import Content, Part, Blob
from google.adk.agents import Agent
from google.adk.tools import ToolContext
from google.adk.agents.callback_context import CallbackContext
from google.adk.models import LlmResponse, LlmRequest
from google.adk.planners import BuiltInPlanner
from google.cloud import geminidataanalytics # Conversational Analytics API


data_chat_client = geminidataanalytics.DataChatServiceClient()
logger = logging.getLogger(__name__)

load_dotenv()
PROJECT_ID = os.getenv("GOOGLE_CLOUD_PROJECT")
REGION = os.getenv("GOOGLE_CLOUD_LOCATION")
BQ_DATASET = os.getenv("BQ_DATASET")
DATA_AGENT_ID = os.getenv("DATA_AGENT_ID")
CONVERSATION_ID = os.getenv("CONVERSATION_ID")

def add_data_sources(table_names:[], bq_dataset_id:str, project_id:str) -> None: 
    
    print("inside add_data_sources()")
    
    bigquery_table_references=[]
    
    for table_name in table_names:
            bigquery_table_reference = geminidataanalytics.BigQueryTableReference()  
            bigquery_table_reference.project_id = project_id
            bigquery_table_reference.dataset_id = bq_dataset_id
            bigquery_table_reference.table_id = table_name 
            bigquery_table_references.append(bigquery_table_reference)
            print("Added table", table_name)  
    return bigquery_table_references


def create_data_agent(project_id:str, bq_dataset:str, parent_agent_name:str, data_agent_name:str, data_agent_id:str)-> bool:
    """ make the request to see if the agent was created; if not create it"""
    
    success = True
    
    try:
        data_agent_client = geminidataanalytics.DataAgentServiceClient()
        request_list = geminidataanalytics.ListDataAgentsRequest(parent=parent_agent_name,)       
        page_result = data_agent_client.list_data_agents(request=request_list)
        
        exist_agent = False
        
        for response in page_result:
            if (str(response.name) == data_agent_name):
                logger.info(f"Data Agent  {data_agent_name} already exists")
                exist_agent = True
                break
        
        if not exist_agent:
            logger.info("Creating a new data agent  %s", data_agent_name)
            data_agent_client = geminidataanalytics.DataAgentServiceClient()
            bigquery_table_references=[]

            table_names = ["Aircraft","Airline","Airport","Airport_Concessions","Airport_Establishment","Airport_Review", "Country", \
                           "Flight_Delays", "Flight_Routes", "Food_Beverage", "Route_Equipment", "TSA_Traffic"]
            bigquery_table_references =  add_data_sources(table_names, bq_dataset, project_id)

            datasource_references = geminidataanalytics.DatasourceReferences()
            datasource_references.bq.table_references = bigquery_table_references
        
            # set up context for stateful chat
            published_context = geminidataanalytics.Context()
            published_context.system_instruction = "The air travel dataset contains clean data on airports, airlines, flights. \
                                                    Please discover the joins between the tables and help the user explore the data"
            published_context.datasource_references = datasource_references
            published_context.options.analysis.python.enabled = True # optional

            data_agent = geminidataanalytics.DataAgent()
            data_agent.data_analytics_agent.published_context = published_context
            data_agent.name = data_agent_name # optional

            request = geminidataanalytics.CreateDataAgentRequest(
                parent = parent_agent_name,
                data_agent_id = data_agent_id,
                data_agent = data_agent,
            )
            
            operation = data_agent_client.create_data_agent(request=request)
            logger.info(f"Data Agent created: {data_agent_name}. Operation {operation}")
            
            
    except Exception as e:
        logger.error(f"Error creating Data Agent: %s", str(e))
        success = False
        
    return success
        

def create_conversation(parent_agent_name:str, data_agent_name:str, conversation_name:str, conversation_id) -> str:
    """" create the conversation for the agent """
    
    conversation_resp_id = None

    print("inside create_conversation()")
    
    try:
        # create conversation
        conversation = geminidataanalytics.Conversation()
        data_chat_client = geminidataanalytics.DataChatServiceClient()

        conversation.agents = [data_agent_name]
        conversation.name = conversation_name
        request = geminidataanalytics.CreateConversationRequest(
            parent=parent_agent_name,
            conversation_id=conversation_id,
            conversation=conversation,
        )
         
        # make the request to create the conversation
        response = data_chat_client.create_conversation(request=request)
        print("created conversation:", response)
        
        conversation_resp_id = response.name.split("/")[5]
        print("conversation_resp_id:", conversation_resp_id)
        
        logger.info("Conversation created: %s", str(response))
    
    except Exception as e:
        logger.error(f"Error creating conversation: %s", str(e))
        
    return conversation_resp_id


def setup_before_agent_call(callback_context: CallbackContext):
    """ Setup the data agent and conversation """
    
    print("inside setup_before_agent_call()")
    
    success = True
    
    if "conversation_name" not in callback_context.state:
        
        print("conversation not set")
                
        conversation_id = callback_context.invocation_id
        callback_context.state["conversation_id"] = CONVERSATION_ID
        conversation_name =  f"projects/{PROJECT_ID}/locations/global/conversations/{CONVERSATION_ID}"
        parent_agent_name = f"projects/{PROJECT_ID}/locations/{REGION}"
        data_agent_name = f"{parent_agent_name}/dataAgents/{DATA_AGENT_ID}"
        
        callback_context.state["project_id"] = PROJECT_ID
        callback_context.state["region"] = REGION
        callback_context.state["parent_agent_name"] = parent_agent_name
        callback_context.state["data_agent_name"] =  data_agent_name
        callback_context.state["data_agent_id"] = DATA_AGENT_ID
        callback_context.state["conversation_name"] = conversation_name
        
        print("project_id:", callback_context.state["project_id"])
        print("conversation_id:", callback_context.state["conversation_id"])
        print("conversation_name:", callback_context.state["conversation_name"])
        print("data_agent_id:", callback_context.state["data_agent_id"])
        print("data_agent_name:", callback_context.state["data_agent_name"])

        success = create_data_agent(PROJECT_ID, BQ_DATASET, parent_agent_name, data_agent_name, DATA_AGENT_ID)
        
        if success != True:
            return None
        
        conversation_resp_id = create_conversation(parent_agent_name, data_agent_name, conversation_name, conversation_id)
        
        if conversation_resp_id != None:
            callback_context.state["conversation_resp_id"] = conversation_resp_id
    
    else:
        print("conversation is already set")
        print("project_id:", callback_context.state["project_id"])
        print("project_id:", callback_context.state["region"])
        print("conversation_id:", callback_context.state["conversation_id"])
        print("conversation_resp_id:", callback_context.state["conversation_resp_id"])
        print("conversation_name:", callback_context.state["conversation_name"])
        print("data_agent_id:", callback_context.state["data_agent_id"])
        print("data_agent_name:", callback_context.state["data_agent_name"])


async def ask_question(question: str, tool_context: ToolContext) -> list:
    
    """
    Queries the Conversational Analytics API. Returns the response as text. 
    """
    
    print("inside ask_question()")
    print("question:", question)
    
    project_id = tool_context.state.get("project_id")
    region = tool_context.state.get("region")
    parent_agent_name = tool_context.state.get("parent_agent_name")
    data_agent_id = tool_context.state.get("data_agent_id")
    data_agent_name = tool_context.state.get("data_agent_name")
    conversation_name = tool_context.state.get("conversation_name")
    conversation_id = tool_context.state.get("conversation_id")
    conversation_resp_id = tool_context.state.get("conversation_resp_id")
    
    print("project_id:", project_id)
    print("region:", region)
    print("data_agent_id:", data_agent_id)
    print("data_agent_name:", data_agent_name)
    print("parent_agent_name:", parent_agent_name)
    print("conversation_id:", conversation_id)
    print("conversation_resp_id:", conversation_resp_id)

    messages = [geminidataanalytics.Message()]
    messages[0].user_message.text = question
    
    conversation = data_chat_client.conversation_path(project_id, region, conversation_resp_id)
    data_agent = data_chat_client.data_agent_path(project_id, region, data_agent_id)

    conversation_reference = geminidataanalytics.ConversationReference()
    conversation_reference.conversation = conversation
    conversation_reference.data_agent_context.data_agent = data_agent_name

    request = geminidataanalytics.ChatRequest(
        parent = parent_agent_name,
        messages = messages,
        conversation_reference = conversation_reference
    )

    # make the request
    stream = data_chat_client.chat(request=request)
    
    # handle the response
    responses = []
    for response in stream:
        responses.append(str(response.system_message))
    
    return responses
    

async def ask_question_plot(question: str, tool_context: ToolContext) -> Dict[str, Any]:
    """
    Queries the Conversational Analytics API, extracts plot data (Vega-Lite), and renders it as a png.
    Saves the image as the ADK artifact repository. 
    """
    try:
        
        print("inside ask_question_plot()")
        print("question:", question)
    
        # --- 1. Call the API ---
        project_id = tool_context.state.get("project_id")
        region = tool_context.state.get("region")
        parent_agent_name = tool_context.state.get("parent_agent_name")
        data_agent_id = tool_context.state.get("data_agent_id")
        data_agent_name = tool_context.state.get("data_agent_name")
        conversation_name = tool_context.state.get("conversation_name")
        conversation_id = tool_context.state.get("conversation_id")
        conversation_resp_id = tool_context.state.get("conversation_resp_id")
    
        print("project_id:", project_id)
        print("region:", region)
        print("data_agent_id:", data_agent_id)
        print("data_agent_name:", data_agent_name)
        print("parent_agent_name:", parent_agent_name)
        print("conversation_id:", conversation_id)
        print("conversation_resp_id:", conversation_resp_id)

        messages = [geminidataanalytics.Message()]
        messages[0].user_message.text = question
    
        conversation = data_chat_client.conversation_path(project_id, region, conversation_resp_id)
        data_agent = data_chat_client.data_agent_path(project_id, region, data_agent_id)

        conversation_reference = geminidataanalytics.ConversationReference()
        conversation_reference.conversation = conversation
        conversation_reference.data_agent_context.data_agent = data_agent_name

        request = geminidataanalytics.ChatRequest(
            parent = parent_agent_name,
            messages = messages,
            conversation_reference = conversation_reference
        )
        
        stream = data_chat_client.chat(request=request)
     
        # --- 2. Process the Streaming Response ---
        for reply in stream:
            if reply.system_message and reply.system_message.chart:
                if "result" in reply.system_message.chart:
                    # --- 3. Extract and Render the Chart ---
                    # Function to safely convert protobuf map/composite types to Python dicts
                    def _convert_proto(v):
                        if isinstance(v, proto.marshal.collections.maps.MapComposite):
                            return {k: _convert_proto(v) for k, v in v.items()}
                        elif isinstance(v, proto.marshal.collections.RepeatedComposite):
                            return [_convert_proto(el) for el in v]
                        elif isinstance(v, (int, float, str, bool)):
                            return v
                        else:
                            return MessageToDict(v)

                    # Extract the Vega-Lite specification
                    vega_config = _convert_proto(reply.system_message.chart.result.vega_config)
                    print("vega_config:", vega_config)
                    
                    # Use Altair to create the Chart object with the Vega-Lite spec
                    plot = altair.Chart.from_dict(vega_config)
                    
                    # Save plot as png 
                    buffer = BytesIO()
                    plot.save(buffer, format='png')
                    buffer.seek(0)
                    plot.display()

                    # --- 4. Save the PNG to ADK Artifacts ---
                    # Create the ADK Part object for binary data
                    plot_artifact = Part(
                        inline_data = Blob(
                            mime_type="image/png",
                            data=buffer.read()
                        )
                    )
                    filename = f"plot_artifact.png"                    
                    # Save the artifact using the ToolContext (must use await)
                    version = await tool_context.save_artifact(
                        filename=filename,
                        artifact=plot_artifact
                    )
                    # --- 5. Return the Result ---
                    return {
                        "status": "success",
                        "message": "Plot saved to session artifacts",
                        "filename": filename,
                        "version": version
                    }

        
        return {"status": "warning", "message": "Query successful, but no plot data was returned by API"}

    except Exception as e:
        logger.error(f"An error occurred during plot processing: {e}")
        return {"status": "exception", "error": f"An error occurred during chart processing: {e}"}



root_agent = Agent(
    name="qna_agent",
    model="gemini-2.5-pro",
    description=(
        "Agent that uses the Conversational Analytics API to help the user explore the air travel dataset"
    ),
    planner=BuiltInPlanner(thinking_config=ThinkingConfig(include_thoughts=True)
    ),
    instruction=(
        "You are a helpful agent who answers user questions about air travel based on the BigQuery dbt_air_travel_int dataset. \
         The function, setup_before_agent_call, creates the data agent and conversation. You should call it once before calling the tools. \
         If the user asks for a chart or plot, use the ask_question_plot tool. Once the image is saved as an artifact, please let the user know \
         where they can retrieve it from. \
         If the user doesn't ask for a visualization, use the ask_question tool which emits only text. \
         Both tools look up the user's query with the Conversational Analytics API."
    ),
    before_agent_callback=setup_before_agent_call,
    tools=[ask_question, ask_question_plot],
    generate_content_config=types.GenerateContentConfig(http_options=types.HttpOptions(
                            retry_options=types.HttpRetryOptions(initial_delay=1, attempts=2),),)
    )
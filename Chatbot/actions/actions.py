# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/custom-actions

import requests
import json
from typing import Any, Text, Dict, List

from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher


print("in the damn actions server!!!")

def send_request(playload):
    sentiment_url = "http://127.0.0.1:8000/predict_sentiment"
    sentiment_headers = {"Content-Type": "application/json"}
    response = requests.post(sentiment_url, json= playload, headers= sentiment_headers)
    if response.status_code == 200:
        return response.json()
    else:
        return f"Error: {response.status_code} - {response.text}"
    
class ActionSentimentAnalysis(Action):


    
    def name(self) -> Text:
        return "action_sentiment_analysis"

    def run(self,
            dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        print("in action server ya ")
        latest_message = tracker.latest_message.get('text')
        sentiment_playload = {"text": latest_message}
        print(f"last message: {latest_message}")
        data = send_request(sentiment_playload)
        print(f"this is data{data}")
        dispatcher.utter_message(text= " تبيّن معي أنّك  "  + data['label'])

        return []

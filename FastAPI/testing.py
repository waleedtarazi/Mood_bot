from transformers import AutoTokenizer, AutoModelForSequenceClassification, pipeline
from fastapi import FastAPI
from models import SentimentInput
from typing import Dict, Union


app = FastAPI()

sentiment_labels = {
    'LABEL_0': "حزين وواعي",
    'LABEL_1': "مبسوووط"
}

tokenizer = AutoTokenizer.from_pretrained("D:/University/5th_year/Graduation/ChatBot/AraBERT")
model = AutoModelForSequenceClassification.from_pretrained("D:/University/5th_year/Graduation/ChatBot/AraBERT")
sentiment = pipeline('sentiment-analysis', model=model, tokenizer=tokenizer)

def make_prediction(text: str) -> Dict[str, Union[str, int]]:
    result = sentiment(text)[0]
    label_id = result['label']
    label = sentiment_labels[label_id]
    score = result['score']
    return {"text": text ,"label": label, "score": score}

 
@app.post('/predict_sentiment', status_code= 200)
async def predict(input_text: SentimentInput):
    return  make_prediction(input_text.text)

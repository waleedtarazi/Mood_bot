from pydantic import BaseModel

class SentimentInput(BaseModel):
    text: str
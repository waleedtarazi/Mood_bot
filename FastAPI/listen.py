import requests

url = "http://127.0.0.1:8000/predict_sentiment"
playload = {"text": "انا احبك"}
headers = {"Content-Type": "application/json"}

response = requests.post(url, json= playload, headers= headers)

if response.status_code == 200:
    data = response.json()
    label = data['label']
    score = data['score']
    text = data['text']
    print(f"predicted sentmen for this sentance {text} is: {label}, with score of {score}")
else:
    print(f"Error: {response.status_code} - {response.text}")
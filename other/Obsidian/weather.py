import requests
import json

API_KEY = ""
CITY = "Berkeley, US"

response = requests.get(f"http://api.openweathermap.org/data/2.5/weather?q={CITY}&appid={API_KEY}")
data = json.loads(response.text)

weather_desc = data['weather'][0]['description']
temp = data['main']['temp']

with open('weather.md', 'w') as f:
    f.write(f"## Weather Report\n\n")
    f.write(f"Description: {weather_desc}\n")
    f.write(f"Temperature: {temp}\n")

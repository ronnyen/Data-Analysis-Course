import requests
import pymongo
import random
import pandas as pd

# 1. get your api key - https://console.developers.google.com/apis/dashboard
#    and add the key to API_KEYS
API_KEYS = ['AIzaSyAka3lKT0r8j2cIga518LpQCZXiid9NHfY', 'add_your_key']
uri = 'mongodb://ronny:12345@ds231228.mlab.com:31228/videos' 

# list of 3685 video ids, videos that appeared on the trending list from 14/11/17 to 7/2/18
df = pd.read_csv('data/videos.csv')
len(df) # 3685

# # split the list between us
# # 2. uncomment your df
# # efrat
# df = df[:1000]
# # yaara
# df = df[1000:2000].reset_index()
# # ronny
# df = df[2000:].reset_index()

# list of ids to call the api
# 3. call 100 ids at a time, repeat 10 times
video_ids = df.loc[0:99, 'video_id']


# list for all the api responses
videos_json = []

# call the api
for video in video_ids:
    k = random.randint(0,1)
    API_KEY = API_KEYS[k]
    url = "https://www.googleapis.com/youtube/v3/videos?part=contentDetails,recordingDetails,topicDetails,snippet,statistics&id="+video+"&key="+API_KEY
    r = requests.get(url)
    get_json = r.json()
    videos_json.append(get_json)

# insert videos_json to mongodb
client = pymongo.MongoClient(uri)
db = client.get_database()
# 4. change the collection name to your name
collection = db['yourname']
collection.insert_many(videos_json)
client.close()

# 5. check the db to see the collection - https://mlab.com/databases/videos


#1
import requests
r = requests.get('http://jsonplaceholder.typicode.com/posts')
collection = r.json()
print(collection)
print(type(collection), type(collection[0]))

#2
import sqlite3
conn = sqlite3.connect('db/Chinook_Sqlite.sqlite')
c = conn.cursor()
print("ok")
c.execute('''select distinct(Invoice.BillingCountry) 
from Invoice''')
countries = c.fetchall()
cuntries_list = []
for country in countries:
    cuntries_list.append(country[0])
result = {}
for i in range(len(cuntries_list)):
    result[cuntries_list[i]] = []
c.execute('''select Invoice.InvoiceId, Invoice.BillingCountry 
from Invoice''')
invoices = c.fetchall()
for invoice in invoices:
    result[invoice[1]].append(invoice[0])
print(result)

for key, value in result.items():
    print(key, len(value))

conn.close()

#3
try:
 from pymongo import MongoClient
 conn2 = MongoClient('ds127854.mlab.com', 27854)
 db = conn2.get_database('rest-mongo-practice')
 db.authenticate('data', 'data123')
 restaurants = db.get_collection('restaurants').find({"$and": [{"cuisine" : "Donuts"}, {"borough" : "Manhattan"}]})
 rests = [['cuisine', 'restaurant_id', 'street', 'building']]
 for restaurant in restaurants:
    rest = []
    rest.append(restaurant['name'])
    rest.append(restaurant['restaurant_id'])
    rest.append(restaurant['address']['street'])
    rest.append(restaurant['address']['building'])
    # print(rest)
    rests.append(rest)
 print(rests)
 conn2.close()
except IOError:
    print("Error: cannot connect to rest-mongo-practice" )


import csv
myFile = open('restaurants.csv', 'w', newline='')
with myFile:
   writer = csv.writer(myFile)
   writer.writerows(rests)

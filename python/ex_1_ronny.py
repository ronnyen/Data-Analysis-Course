from datetime import datetime

#1
list_1 = ['a', 1, 'foo', ['a', 'b', 3]]
print(list_1[1])

#2
list_2 = ['a', 1, 'foo', ['a', 'b', 3]]
print(list_2[3][1])

#3
sum_13 = 0 

for x in range(1000):
    if x%13 == 0:
        sum_13 += x
print(sum_13)

#4
list_4 = [1, 4, 3, 21, 12, 8]
list_4.sort(reverse=True)
print(list_4[1])

#5
years = [1984, 1982, 1990, 1985, 1992, 1991]
year_now = datetime.now().year
for x in years:
    print("people who were born in ", x, "are ", year_now - x, "years old now")

#6
# x = 0
# y = []
# while x == 0:
#     y.append(1)

#7

def foo():
    bar()


def bar():
    foo()

# foo()

#8
try:
 foo()
except:
 print("Error")



#9
grades = {'John' : 87,
          'Alice' : 98,
          'Bob' : 55,
          'Charlie' : 45,
          'Dave' : 72
         }

for key, value in grades.items():
    if value > 90:
        print(key, 'A')
    if value < 90 and value > 80:
        print(key, 'B')
    if value < 80 and value > 70:
        print(key, 'C')
    if value < 70 and value > 60:
        print(key, 'D')
    if value < 60:
        print(key, 'F')

#11-a
try:
 from pymongo import MongoClient
 conn2 = MongoClient('ds127854.mlab.com' , 27854)
 db = conn2.get_database('rest-mongo-practice')
 db.authenticate('data', 'data123')
 boroughs = db.get_collection('restaurants').distinct("borough")
 for borough in boroughs:
    print(borough)
 conn2.close()
except IOError:
    print("Error: cannot connect to rest-mongo-practice" )

#11-b
try:
 my_file = open('hello.txt', 'w')
 print(my_file.write('hello file!'))
 my_file.close()
except IOError:
 print('Error: can not find file or read data')

#12
import requests
r = requests.get('http://jsonplaceholder.typicode.com/posts')
print(r.text)

#13
r = requests.get('http://jsonplaceholder.typicode.com/posts')
last = r.json()[-1]
print(last['id'])

#14
import sqlite3
conn = sqlite3.connect('db/Chinook_Sqlite.sqlite')
c = conn.cursor()
print("ok")
c.execute('''select Genre.Name, count(*) as 'Track count'
from Genre join Track
on Genre.GenreId = Track.GenreId
group by Genre.GenreId''')
genres = c.fetchall()
for genre in genres:
 print(genre)
conn.close()




# THIS FILE IS FOR TESTING PURPOSES

# Imports packages
import connect

# Connects to the database
(cursor, connection) = connect.database()

# User information
email = "fake_email@gmail.com"
name = "Billy Bob"
password = "password123456"

# Creates a user
insert_query = '''INSERT INTO user_data (email, name, password) 
                  VALUES (?, ?, ?);'''
values = (email, name, password)
cursor.execute(insert_query, values)
connection.commit()
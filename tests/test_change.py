# THIS FILE IS FOR TESTING PURPOSES

# Imports packages
import connect

# Connects to the database
(cursor, connection) = connect.database()

# User information
email = "fake_email@gmail.com"

# Changes the email of a user
insert_query = '''UPDATE user_data SET email = ? WHERE email = ?'''
new_email = "new_email@gmail.com"
values = (new_email, email)
cursor.execute(insert_query, values)
connection.commit()
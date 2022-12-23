# THIS FILE IS FOR TESTING PURPOSES

# Imports packages
import connect

# Connects to the database
(cursor, connection) = connect.database()

# User information
email = "new_email@gmail.com"

# Deletes a user
insert_query = '''DELETE FROM user_data WHERE email = ?'''
cursor.execute(insert_query, email)
connection.commit()
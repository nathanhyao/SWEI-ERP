# Imports packages
from datetime import date
import connect
import user_control

# Connect to the database
(cursor, connection) = connect.database()

# Sends the shift start time to the database
def start(email, time):
    insert_query = '''INSERT INTO time_data (email, start_time) 
                  VALUES (?, ?);'''
    values = (email, time)

    cursor.execute(insert_query, values)
    connection.commit()

# Sends the shift end time to the database
def end(email):
    insert_query = '''DELETE FROM time_data WHERE email = ?'''

    cursor.execute(insert_query, email)
    connection.commit()

# Retrieves the current shift start time from the database
def get_start(email):
    insert_query = '''SELECT start_time FROM time_data WHERE email = ?'''

    cursor.execute(insert_query, email)
    time = cursor.fetchall()
    if (time == []):
        return 0
    else:
        return time[0][0]
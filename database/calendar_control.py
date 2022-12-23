# Imports packages
import connect
import time

# Connect to the database
(cursor, connection) = connect.database()

# Sends a new event to the database
def create_event(email, name, time_start, time_end, is_time_off):
    is_shift = "True"
    is_off = "False"
    if is_time_off:
        is_shift = "False"
        is_off = "True"

    insert_query = '''INSERT INTO calendar_data (email, name, time_start, time_end, is_shift, is_time_off) 
                  VALUES (?, ?, ?, ?, ?, ?);'''
    values = (email, name, time_start, time_end, is_shift, is_off)

    cursor.execute(insert_query, values)
    connection.commit()

# Deletes an event from the database
def remove_event(email, time_start):
    insert_query = '''DELETE FROM calendar_data WHERE email = ? AND time_start = ?;'''
    values = (email, time_start)

    cursor.execute(insert_query, values)
    connection.commit()

# Changes a shift to a new user
def change_event(old_email, new_email, new_name, shift_start, shift_end):
    insert_query = '''UPDATE calendar_data SET email = ?, name = ? WHERE (email = ? AND time_start = ? AND time_end = ?);'''
    values = (new_email, new_name, old_email, shift_start, shift_end)

    cursor.execute(insert_query, values)
    connection.commit()

# Get events from the database
def fetch_events(date):
    insert_query = '''SELECT email, name, time_start, time_end, is_shift, is_time_off FROM calendar_data WHERE SUBSTRING(time_start, 1, 10) = ?;'''

    cursor.execute(insert_query, date)
    event_dict = []
    i = 0
    for event in cursor.fetchall():
        is_shift = False
        is_time_off = False
        if event[4] == "True":
            is_shift = True
        if event[5] == "True":
            is_time_off = True

        event_dict.append({"time_start":event[2], "time_end":event[3], "is_shift":is_shift, "is_time_off":is_time_off, "assigned_name":event[1], "assigned_email":event[0]})
        i = i + 1
    return event_dict

# Sends a new trade request to the database
def create_request(sender_name, sender_email, recipient_name, recipient_email, shift_start_time, shift_end_time):
    insert_query = '''INSERT INTO shift_trade_data (sender_name, sender_email, recipient_name, recipient_email, shift_start_time, shift_end_time) 
                  VALUES (?, ?, ?, ?, ?, ?);'''
    values = (sender_name, sender_email, recipient_name, recipient_email, shift_start_time, shift_end_time)

    cursor.execute(insert_query, values)
    connection.commit()

# Deletes a trade request from the database
def remove_request(sender_email, shift_start_time, shift_end_time):
    insert_query = '''DELETE FROM shift_trade_data WHERE sender_email = ? AND shift_start_time = ? AND shift_end_time = ?'''
    values = (sender_email, shift_start_time, shift_end_time)

    cursor.execute(insert_query, values)
    connection.commit()

# Get incoming shift trade requests from the database
def fetch_incoming(email):
    insert_query = '''SELECT sender_name, sender_email, recipient_name, recipient_email, shift_start_time, shift_end_time FROM shift_trade_data WHERE recipient_email = ?;'''

    cursor.execute(insert_query, email)
    event_dict = []
    i = 0
    for event in cursor.fetchall():
        event_dict.append({"sender_name":event[0], "sender_email":event[1], "recipient_name":event[2], "recipient_email":event[3], "shift_start_time":event[4], "shift_end_time":event[5]})
        i = i + 1
    return event_dict

# Get outgoing shift trade requests from the database
def fetch_outgoing(email):
    insert_query = '''SELECT sender_name, sender_email, recipient_name, recipient_email, shift_start_time, shift_end_time FROM shift_trade_data WHERE sender_email = ?;'''
    time.sleep(.1)

    cursor.execute(insert_query, email)
    event_dict = []
    i = 0
    for event in cursor.fetchall():
        event_dict.append({"sender_name":event[0], "sender_email":event[1], "recipient_name":event[2], "recipient_email":event[3], "shift_start_time":event[4], "shift_end_time":event[5]})
        i = i + 1
    return event_dict
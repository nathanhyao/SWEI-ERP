# Imports packages
from datetime import date, datetime, timedelta
import connect
import user_control

# Connect to the database
(cursor, connection) = connect.database()

# Stores the date of the shift, total shift time
def store(email, hours, income):
    # Create beginning of period information
    current_date = datetime.now()
    first_day = current_date - timedelta(days = current_date.weekday())
    period_date = str(first_day.year) + ":" + str(first_day.month) + ":" + str(first_day.day)

    # Check to see if that period date exists
    insert_query = '''SELECT week FROM pay_data WHERE email = ? AND week = ?'''
    cursor.execute(insert_query, email, period_date)
    time = cursor.fetchall()
    if (time == []):
        # Period does not exist   
        print("here")
        insert_query = '''INSERT INTO pay_data (email, week, hours, income) 
                  VALUES (?, ?, ?, ?);'''
        values = (email, period_date, hours, income)

        cursor.execute(insert_query, values)
        connection.commit()
    else:
        # Period does exist
        insert_query = '''SELECT hours, income FROM pay_data WHERE email = ?'''
        cursor.execute(insert_query, email)
        pay = cursor.fetchall()
        
        # Calculate new values
        old_hours = pay[0][0]
        old_income = pay[0][1]
        new_hours = old_hours + hours
        new_income = old_income + income

        # Add new information to the database
        insert_query = '''UPDATE pay_data SET hours = ?, income = ? WHERE email = ? AND week = ?;'''
        values = (new_hours, new_income, email, period_date)

        cursor.execute(insert_query, values)
        connection.commit()
    
# Gets the stored shifts according to the username
def get(email):
    insert_query = '''SELECT week, hours, income FROM pay_data WHERE email = ?'''

    cursor.execute(insert_query, email)
    pay_dict = []
    i = 0
    for pay in cursor.fetchall():
        # Create beginning of period information
        current_date = datetime.now()
        first_day = current_date - timedelta(days = current_date.weekday())
        period_date = str(first_day.year) + ":" + str(first_day.month) + ":" + str(first_day.day)

        if (pay[0] == period_date):
            pay_dict.append({"week": "Week of: " + pay[0][0:4] + "-" + pay[0][5:7] + "-" + pay[0][8:10], "name": user_control.n_get(email), "weekID": 0, "hours": str(f'{pay[1]:.2f}'), "income":  "$" + str(f'{pay[2]:.2f}')})
        else:
            pay_dict.append({"week": "Week of: " + pay[0][0:4] + "-" + pay[0][5:7] + "-" + pay[0][8:10], "name": user_control.n_get(email), "weekID": 1, "hours": str(f'{pay[1]:.2f}'), "income": "$" + str(f'{pay[2]:.2f}')})
        i = i + 1
    return pay_dict
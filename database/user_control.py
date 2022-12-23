# Imports packages
import connect

# Connect to the database
(cursor, connection) = connect.database()

# Sends all the new user data to the database
def create(email, name, password):
    insert_query = '''INSERT INTO user_data (email, name, password) 
                  VALUES (?, ?, ?);'''
    values = (email, name, password)

    cursor.execute(insert_query, values)
    connection.commit()

# Retrieves all the user data of a specific user from the databse
def get(email):
    insert_query = '''SELECT email, name, password FROM user_data WHERE username = ?'''

    cursor.execute(insert_query, email)
    return cursor.fetchall()[0]

# Retrieves the email of a specific user from the database
def e_get(email):
    insert_query = '''SELECT email FROM user_data WHERE email = ?'''

    cursor.execute(insert_query, email)
    return cursor.fetchall()[0][0]

# Retrieves the email of a specific user from the database
def e_get_name(name):
    insert_query = '''SELECT email FROM user_data WHERE name = ?'''

    cursor.execute(insert_query, name)
    return cursor.fetchall()[0][0]

# Retrieves the name of a specific user from the database
def n_get(email):
    insert_query = '''SELECT name FROM user_data WHERE email = ?'''

    cursor.execute(insert_query, email)
    return cursor.fetchall()[0][0]

# Retrieves the password of a specific user from the database
def p_get(email):
    insert_query = '''SELECT password FROM user_data WHERE email = ?'''

    cursor.execute(insert_query, email)
    return cursor.fetchall()[0][0]

# Changes the email in the database
def e_change(email, new_email):
    insert_query = '''UPDATE user_data SET email = ? WHERE email = ?'''
    values = (new_email, email)

    cursor.execute(insert_query, values)
    connection.commit()

# Changes the password in the database
def p_change(email, new_password):
    insert_query = '''UPDATE user_data SET password = ? WHERE email = ?'''
    values = (new_password, email)

    cursor.execute(insert_query, values)
    connection.commit()

# Changes the name in the database
def n_change(email, new_name):
    insert_query = '''UPDATE user_data SET name = ? WHERE email = ?'''
    values = (new_name, email)

    cursor.execute(insert_query, values)
    connection.commit()

# Retrieves all the user data of a specific team
def t_get(team_id):
    # Currently selecting from default team_id
    insert_query = '''SELECT name, email from user_data'''

    cursor.execute(insert_query)
    
    user_dict = []
    i = 0
    for user in cursor.fetchall():
        user_dict.append({"name":user[0], "email":user[1], "privilege":"User"})
        i = i + 1
    return user_dict


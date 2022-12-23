# Imports packages
import connect

# Connect to the database
(cursor, connection) = connect.database()

# Add a task to the task list
def add(title, team_id):
    insert_query = '''INSERT INTO task_data (title, name, activity, team_id) 
                  VALUES (?, ?, ?, ?);'''
    values = (title, "None", "Available", team_id)

    cursor.execute(insert_query, values)
    connection.commit()

# Remove a task from the task list
def remove(title):
    insert_query = '''DELETE FROM task_data WHERE title = ?'''

    cursor.execute(insert_query, title)
    connection.commit()

# Set a task to be in progress
def in_progress(title, name):
    insert_query = '''UPDATE task_data SET activity = ? WHERE title = ?'''
    values = ("In Progress", title)

    cursor.execute(insert_query, values)
    connection.commit()

    insert_query = '''UPDATE task_data SET name = ? WHERE title = ?'''
    values = (name, title)

    cursor.execute(insert_query, values)
    connection.commit()

def get_tasks(team_id):
    insert_query = '''SELECT title, name, activity FROM task_data WHERE team_id = ?'''

    cursor.execute(insert_query, team_id)

    task_dict = []
    i = 0
    for task in cursor.fetchall():
        task_dict.append({"title":task[0], "name":task[1], "activity":task[2]})
        i = i + 1
    return task_dict
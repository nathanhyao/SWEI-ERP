# Imports packages
import connect

# Connect to the database
(cursor, connection) = connect.database()

# Sends a new annoucement to the database
def create(teamID, annoucement):
    insert_query = '''DELETE FROM annoucement_data WHERE team_id = ?'''

    cursor.execute(insert_query, teamID)
    connection.commit()

    insert_query = '''INSERT INTO annoucement_data (team_id, annoucement) 
                  VALUES (?, ?);'''
    values = (teamID, annoucement)

    cursor.execute(insert_query, values)
    connection.commit()

# Gets an annoucement from the database
def fetch(teamID):
    insert_query = '''SELECT annoucement FROM annoucement_data WHERE team_id = ?;'''
    values = (teamID)

    cursor.execute(insert_query, values)
    time = cursor.fetchall()
    if (time == []):
        return 0
    else:
        return time[0][0]


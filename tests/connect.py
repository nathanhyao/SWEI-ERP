# Import packages
import pyodbc

# Connect to the database
def database():
    # Estbalish server and database data
    server = 'shay-app.database.windows.net'
    database = 'shay_storage'
    username = 'zach_headington'
    password = 'Boilermakerstrong0921$'   
    driver = '{ODBC Driver 17 for SQL Server}'

    # Connect to the server
    connection = pyodbc.connect('DRIVER='+driver+';SERVER=tcp:'+server+';PORT=1433;DATABASE='+database+';UID='+username+';PWD='+ password)
    return connection.cursor(), connection

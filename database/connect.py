# Import packages
import pyodbc

# Estbalish server and database data
server = 'shay-app.database.windows.net'
database = 'shay_storage'
username = 'zach_headington'
password = 'password_hidden (on original private repo)'   
driver = '{ODBC Driver 17 for SQL Server}'

# Connect to the server
connection = pyodbc.connect('DRIVER='+driver+';SERVER=tcp:'+server+';PORT=1433;DATABASE='+database+';UID='+username+';PWD='+ password)

def database():
    return connection.cursor(), connection

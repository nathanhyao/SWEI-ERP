# Import packages
from flask import Flask, jsonify, request
import json

import user_control
import time_control
import task_control
import math_control
import pay_control
import annoucement_control
import calendar_control

# Firebase Admin SDK for Python (for JWT generation)
# import firebase_admin
# from firebase_admin import auth
# from firebase_admin import credentials
# # explicitly pass the path to the service account key in code
# cred = credentials.Certificate(
#     'database/tmp/shay-cea81-firebase-adminsdk-9dntp-4dc66125f4.json')
# firebase_admin.initialize_app(cred)

app = Flask(__name__)


@app.route('/', methods=["POST"])
# When we hit this route '/', we run this function
def home():
    # Determines whether we are using POST and GET
    if request.method == "POST":

        # Get encoded data from user
        request_data = request.data
        # Decode data from user and reassign
        request_data = json.loads(request_data.decode("utf-8"))

        # Request data is a login
        if request_data["key"] == "login":
            email = request_data["email"]
            password = request_data["password"]

            print(f"\nSERVER: {email} Attempting login. {password}\n")

            pwCheck = user_control.p_get(email)

            if password == pwCheck:
                name = user_control.n_get(email)
                # Generate auth token to be sent back to the client
                # custom_token = auth.create_custom_token(email)
                # print(f"\nSERVER: {email}'s JWT: {custom_token}\n")
                # # TODO: Will figure out if should decode or send as str cast
                # return jsonify({"name": name, "custom_token": custom_token.decode('utf-8')}), 200
                return jsonify({"name": name}), 200
                # TODO: Could also pass privilege field (admin/user)
            else:
                return jsonify({"error": "invalid credentials"}), 400

        # Request is to reset password for associated email
        elif (request_data['key'] == 'password_reset'):
            email = request_data['email']
            password = request_data['new_password']

            print(f"\nSERVER: {email} New Password: {password}\n")

            user_control.p_change(email, password)
            return jsonify({"success": "password reset"}), 200

        # Request data is an email change
        elif (request_data['key'] == 'email_reset'):
            email = request_data['email']
            new_email = request_data['new_email']

            print(f"\nSERVER: {email} New email: {new_email}\n")

            user_control.e_change(email, new_email)
            return jsonify({"success": "email change"}), 200

        # Request data is a name change
        elif (request_data['key'] == 'name_reset'):
            email = request_data['email']
            new_name = request_data['new_name']

            print(f"\nSERVER: {email} New name: {new_name}\n")

            user_control.n_change(email, new_name)
            return jsonify({"success": "name change"}), 200

        # Request data is an account creation
        elif (request_data['key'] == 'register'):
            email = request_data['email']
            name = request_data['name']
            password = request_data['password']

            print(f"\nSERVER: {email} Registration. {name} {password}\n")

            user_control.create(email, name, password)

            return jsonify({"success": "account registered"}), 200

        # Request data is a fetching status of user shift (upon opening clock page)
        elif (request_data['key'] == 'shift_fetch'):
            teamID = request_data['teamID']
            email = request_data['email']

            curr_time = time_control.get_start(email)
            if (curr_time == 0):
                return jsonify({'isClockedIn': False, 'clockInTime': "0000-00-00 00:00:00"}), 200
            else:
                return jsonify({'isClockedIn': True, 'clockInTime': curr_time}), 200

        # Request data is a shift start
        elif (request_data['key'] == 'shift_start'):
            teamID = request_data['teamID']
            email = request_data['email']
            clockInTime = request_data['clockInTime']

            print(f"\nSERVER: {email} Starting Shift. {clockInTime}\n")

            time_control.start(email, clockInTime)
            return jsonify({"success": "shift started"}), 200

        # Request data is a shift end
        elif (request_data['key'] == 'shift_end'):
            teamID = request_data['teamID']
            email = request_data['email']
            clockOutTime = request_data['clockOutTime']

            start_time = time_control.get_start(email)
            time_control.end(email)

            print(f"\nSERVER: {email} Ending Shift. {clockOutTime}\n")

            # Calculate time difference and pay
            total_time = math_control.shift_calculate(start_time, clockOutTime)
            print(total_time)
            total_income = total_time * 15

            # Store the total time and total income
            pay_control.store(email, total_time, total_income)

            return jsonify({"success": "shift ended"}), 200

        # Request data is creating a task
        elif request_data["key"] == "task_create":
            title = request_data["title"]
            print(f"\nSERVER: Creating a task with title: {title}\n")

            # Defualt using the teamID 0
            task_control.add(title, 0)
            return jsonify({"success": "task created"}), 200

        # Request data is accepting a task
        elif (request_data['key'] == 'task_accept'):
            title = request_data['title']
            name = request_data['name']
            print(f"\nSERVER: {name} is accepting the task: {title}\n")

            task_control.in_progress(title, name)
            return jsonify({"success": "task assigned"}), 200

        # Request data is removing a task
        elif request_data["key"] == "task_delete":
            title = request_data["title"]
            print(f"\nSERVER: Removing task with title: {title}\n")

            task_control.remove(title)
            return jsonify({"success": "task deleted"}), 200

        # Request data is fetching tasks
        elif request_data['key'] == 'task_fetch':
            teamID = request_data['teamID']
            print(f'\nSERVER: Fetching tasks for teamID: {teamID}\n')

            # Fetch tasks and send them back to the client
            tasks = task_control.get_tasks(teamID)
            return jsonify(tasks), 200

        # Request data is fetching pay page
        elif (request_data['key'] == 'pay_fetch'):
            email = request_data['email']
            print(f'\nSERVER: ? : {email}\n')

            pay_info = pay_control.get(email)
            return jsonify(pay_info), 200

        # Request data is fetching team page
        elif (request_data['key'] == 'team_fetch'):
            teamID = request_data['teamID']
            print(f'\nSERVER: Fetching users for teamID: {teamID}\n')

            users = user_control.t_get(teamID)
            return jsonify(users), 200

        # Request data is fetching team page
        elif (request_data['key'] == 'announcement_fetch'):
            teamID = request_data['teamID']
            print(f'\nSERVER: Fetching announcement for teamID: {teamID}\n')

            annoucement = annoucement_control.fetch(teamID)
            if (annoucement == 0):
                return jsonify({'announcement': ""}), 200
            else:
                return jsonify({'announcement': annoucement}), 200

        # Request data is fetching team page
        elif (request_data['key'] == 'announcement_save'):
            teamID = request_data['teamID']
            new_announcement = request_data['newAnnouncement']
            print(f'\nSERVER: Saving announcement for teamID: {teamID}\n'
                  + f'SERVER: New announcement: {new_announcement}\n')

            annoucement_control.create(teamID, new_announcement)
            return jsonify({'success': 'announcement saved'}), 200

        # Request data is fetching INCOMING trade requests for specified user email
        elif (request_data['key'] == 'incoming_trade_request_fetch'):
            email = request_data['email']
            print(f'\nSERVER: Fetching incoming requests for {email}\n')

            # Retrieve request objects where email is the request recipient
            trade_requests = calendar_control.fetch_incoming(email)

            # Return trade requests where user with 'email' is the request recipient
            return jsonify(trade_requests), 200

        # Request data is creating a trade request
        elif (request_data['key'] == 'trade_request_create'):
            # Gather trade request data
            sender_name = request_data['sender_name']
            sender_email = request_data['sender_email']
            recipient_name = request_data['recipient_name']
            recipient_email = request_data['recipient_email']
            shift_start_time = request_data['shift_start_time']
            shift_end_time = request_data['shift_end_time']

            # Sends information to the database
            calendar_control.create_request(sender_name, sender_email, recipient_name, recipient_email,
                                            shift_start_time, shift_end_time)

            return jsonify({'success': 'trade request saved'}), 200

        # Request data is fetching OUTGOING trade requests for specified user email
        elif (request_data['key'] == 'outgoing_trade_request_fetch'):
            email = request_data['email']
            print(f'\nSERVER: Fetching outgoing requests for {email}\n')

            # Retrieve request objects where email is the request maker
            trade_requests = calendar_control.fetch_outgoing(email)

            # Return trade requests where user with 'email' is the request maker
            return jsonify(trade_requests), 200

        # Request data is ACCEPTING A TRADE REQUEST (Make Users Swap Shifts (Swap users for two shift entries))
        elif (request_data['key'] == 'trade_request_accept'):
            sender_name = request_data['sender_name']
            sender_email = request_data['sender_email']
            recipient_name = request_data['recipient_name']
            recipient_email = request_data['recipient_email']
            # Time format: yyyy-MM-dd HH:mm
            shift_start_time = request_data['shift_start_time']
            shift_end_time = request_data['shift_end_time']

            print(f'\nSERVER: Completing Shift Trade\n')

            calendar_control.change_event(
                recipient_email, sender_email, sender_name, shift_start_time, shift_end_time)
            calendar_control.remove_request(
                sender_email, shift_start_time, shift_end_time)
            # Return trade requests where user with 'email' is the request recipient
            return jsonify({'success': 'shift trade accepted'}), 200

        # Request data is DENYING OR CANCELING A TRADE REQUEST (Make Users Swap Shifts (Swap users for two shift entries))
        elif (request_data['key'] == 'trade_request_delete'):
            sender_email = request_data['sender_email']
            shift_start_time = request_data['shift_start_time']
            shift_end_time = request_data['shift_end_time']

            print(f'\nSERVER: Deleting Shift Trade from {sender_email}\n')

            calendar_control.remove_request(
                sender_email, shift_start_time, shift_end_time)
            # Return trade requests where user with 'email' is the request recipient
            return jsonify({'success': 'shift trade deleted'}), 200

        # Request data is to fetch all events (shifts, time-offs) for the specified date
        elif (request_data['key'] == 'event_fetch'):
            teamID = request_data['teamID']  # Ignore as desired
            date = request_data['date']  # Format yyyy-MM-dd

            print(f'\nSERVER: Getting events for date: {date}\n')

            # Retrieve all events for the specified date
            events = calendar_control.fetch_events(date)

            # Return events for that day
            return jsonify(events), 200

        # Request data is to create an event
        elif (request_data['key'] == 'event_create'):
            teamID = request_data['teamID']  # Ignore as desired

            name = request_data['name']  # User assigned to event
            email = user_control.e_get_name(name)
            start_time = request_data['start']  # Time Format: yyyy-MM-dd HH:mm
            end_time = request_data['end']  # Time Format: yyyy-MM-dd HH:mm

            # True if event is time-off. False if event is shift
            is_time_off = request_data['is_time_off']

            calendar_control.create_event(email, name, start_time, end_time, is_time_off)

            return jsonify({'success': 'event created'}), 200

        # Request data is to delete an event
        elif (request_data['key'] == 'event_delete'):
            email = request_data['assigned_email']
            time_start = request_data['time_start']

            calendar_control.remove_event(email, time_start)
            return jsonify({'success': 'event deleted'}), 200

        # Request data is to change an event
        elif (request_data['key'] == 'event_change'):
            old_email = ""
            old_name = ""
            new_email = ""
            new_name = ""
            shift_start = request_data['time_start']
            shift_end = request_data['time_end']

            calendar_control.change_event(
                old_email, old_name, new_email, new_name, shift_start, shift_end)
            return jsonify({'success': 'event changed'}), 200


# Execution start point for app.py
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)

# __Enterprise Resource Planning Software__

## _(called "Shay")_

Team 22's CS 307 Project is a __team collaboration app / lightweight enterprise resource planning (ERP) software__

Follows client-server architecture. The client uses Flutter. Server uses Flask and performs database queries to SQL Server.

__Contributors__: Nathan Yao, Zach Headington, Justin Schoch, CJ Ackler

- [Final Presentation](https://docs.google.com/presentation/d/1S46sqqYYbTQZbUtud7uszxeaPKte2AJktyPr_vLUlMc/edit?usp=sharing)
- [Video Demonstration](https://vimeo.com/manage/videos/783841977?embedded=false&source=video_title&owner=191337749)

# Overview and Demonstration

## __Authentication__
- __login__ and __registration__ (of course)
- a __forgot password__ option

<img src="" width="300" height="614" />

---

## __Basic Features__
- the __timecard__ lets you clock in/out of work
- the shift's duration is used to calculate earnings
- the __pay-period__ tracker shows earnings by week
- write team-wide __announcements__ on the home screen
- the __roster__ lists all team members
- update account details in __settings__

<img src="" width="300" height="614" />

---

## __Tasks__
- __create tasks__ that will appear on the team __task board__
- self-assign tasks or mark them as complete

<img src="" width="300" height="614" />

---

## __Schedules__
- use the __calendar__ to view events by date
- calendar events are either "shifts" or "time-offs"
- __create events__ by selecting a start time, end time, and the assignee
- the __shift trade__ feature lets workers easily swap shifts with each other

<img src="" width="300" height="614" />

---

## __Messaging__
- __message and chat__ with teammates in real-time
- send files and photos in chat rooms

<img src="" width="300" height="614" />

---

# [Sprint Planning 3](https://docs.google.com/document/d/1LA7tjVc4iiWkAv2D4wDAuWDxBbsThOUA4OJsHfbHypU/edit?usp=sharing)

## ~~**User Story #1** As a user, I would like to see my assigned hours in a calendar~~
- Given that the calendar UI is implemented correctly, when the user enters the calendar page, users can see a list of scheduled shifts and other events.
- Given that the shift/event widgets are implemented correctly, when the user enters the calendar, the shift and events should be pulled from the database and displayed
- Given that the calendar screen is implemented correctly, when the user views the calendar page, each shift/event screen will contain information such as shift/event time (and the assignee if applicable)

## ~~**User Story #2** As a user, I would like to have the capability of requesting time off~~
- Given the request time-off feature is implemented correctly, when the user requests time off, the admin will be notified about the request
- Given the request time-off feature is implemented correctly, while in the add-event page, the user will be able to request a period of time to not be assigned work
- Given the request time-off feature is implemented correctly, while in the request time-off page, the user will be able to cancel a request for time off

## ~~**User Story #3** As a user, I would like to have the capability of requesting a shift trade with another user~~
- Given the shift trade feature is implemented correctly, when in the appropriate page, the user will be able to choose to request a trade for a shift
- Given the shift trade feature is implemented correctly, when the user request a shift trade, the specific trade request will be stored in the database
- Given the shift trade feature is implemented correctly, when a user requests a shift trade, they will be notified the request is made

## ~~**User Story #4** As a user, I would like to see the status of my requests~~
- Given the shift trade page is implemented correctly, when accessing the page, users can see whether their trade request has been accepted
- Given the shift trade feature correctly, when accessing the page, users can see details of the shifts being traded (e.g., times, names)
- Given the shift trade feature is implemented correctly, when the user request a shift trade the status of this request will be stored in the database

## ~~**User Story #5** As a user, I would like to be able to see all my shift trade requests~~
- Given the shift trade page is implemented correctly, when accessing the page, users can see their shift trade requests and their details
- Given the shift trade feature correctly, when accessing the page, shift trades will be pulled from the database and displayed for the requesting user
- Given the shift trade feature correctly, when accessing the page, shift trades will be pulled from the database and displayed for the request recipient

## ~~**User Story #6** As a user, I would like to be able to accept shift trade requests~~
- Given the accept shift trade feature is implemented correctly, when the user presses the button to accept a shift, the shift will be assigned to them
- Given the accept shift trade feature is implemented correctly, when the user accepts a shift the new shift data will be sent to the server
- Given the accept shift trade feature is implemented correctly, when the user accepts a shift the calendar page will update to show the new shift owner

## ~~**User Story #7** As a user, I would like to be able to deny shift trade requests~~
- Given the deny shift trade feature is implemented correctly, when the user presses the button to deny a shift, the shift request goes away
- Given the deny shift trade feature is implemented correctly, when the user denies a trade request, the request is modified or removed from the database
- Given the deny shift trade feature is implemented correctly, when the user denies a trade request, they will be prompted that they have denied the request

## ~~**User Story #8** As a user, I would like the ability to utilize the chat function easily~~
- Given that the user interface for the chat system is implemented correctly, when the user presses the chat icon on the homepage, the user is displayed the chat page.
- Given that the user interface for the chat system is implemented correctly, when the user is on the chat page, then the user will have the option to send a new message.
- Given that the user interface for the chat system is implemented correctly, when the user is on the chat page, then the user will be able to access messages sent to the user.

## ~~**User Story #9** As a user, I would like the ability to send other people messages~~
- Given that the chat function is implemented correctly, when a user enters the chat tab, they are prompted with a box to type the message
- Given that the chat function is implemented correctly and the user sends the message to the global chat, the other users will receive the message
- Given that the database is connected correctly, that new message will be stored in the database

## ~~**User Story #10** As a user, I would like the ability to receive messages from other users~~
- Given that the chat function is implemented correctly, when the user enters the chat tab, they will receive messages from the other individual as they are sent
- Given that the chat function is implemented correctly, the user will be able to view all received messages in the global chat
- Given that the database is connected correctly, that new message will be stored in the database

## ~~**User Story #11** As a user, I would like the ability to send emojis in messages~~
- Given that the chat function is implemented correctly, users can select emojis to send in messages
- Given that the chat function is implemented correctly, users can send emojis in messages
- Given that the chat function is implemented correctly, users can receive emojis in messages

## ~~**User Story #12** As a user, I would like the ability to send gifs in messages~~
- Given that the chat function is implemented correctly, users can select gifs to send in messages
- Given that the chat function is implemented correctly, users can send emojis gifs in messages
- Given that the chat function is implemented correctly, users can receive gifs in messages

## ~~**User Story #13** As an administrator, I would like the ability to assign hours to users~~
- Given that the calendar is implemented correctly, administrators can assign hours to a calendar for a user
- Given that the calendar is implemented correctly, the user assigned to the specified hours can view them on the calendar
- Given that the calendar is implemented correctly, a prompt will appear verifying that the hours were assigned

## ~~**User Story #14** As an administrator, I would like the ability to remove hours from users~~
- Given that the calendar is implemented correctly, administrators can remove hours assigned from a specific user
- Given that the calendar is implemented correctly, the user assigned to the specified hours will have them removed on their calendar
- Given that the calendar is implemented correctly, a prompt will appear verifying that the hours were removed

## ~~**User Story #15** As an administrator, I would like the ability to approve user requests for time off~~
- Given the approve time off feature is implemented correctly, when an admin denies time off, a prompt will notify that the time off request is denied
- Given the approve time off feature is implemented correctly, when an admin denies time off, the database will modify or remove the time off request
- Given the approve time off feature is implemented correctly, when the an admin denies a time off request, it’s closed and removed, if applicable

## ~~**User Story #16** As an administrator, I would like the ability to add events to the team's calendar~~
- Given that the add events feature is implemented correctly, when on the add event page, users can fill in details for the event (e.g., start time).
- Given that the add events feature is implemented correctly, after adding an event, the event will show up on the corresponding calendar timeline.
- Given that the add events feature is implemented correctly, after creating an event, the user will be notified that their event is created.

## ~~**User Story #17** As an administrator, I would like the ability to remove events from the team's calendar~~
- Given that the admin remove event feature is implemented correctly, administrators can remove events from the calendar
- Given that the admin remove event feature is implemented correctly, a message will be displayed showing the remove was completed
- Given that the admin remove event feature is implemented correctly, the new event list will be updated in the database

## ~~**User Story #18** As an administrator, I would like the ability to retroactively modify a user’s time entries~~
- Given that the admin time modification feature is implemented correctly, the admin will be able to modify users time entries
- Given that the admin time modification feature is implemented correctly, the time entries will be updated correctly in the database
- Given that the admin time modification feature is implemented correctly, a message will display showing the change was completed

---

# [Sprint Planning 2](https://docs.google.com/document/d/1iIuuwXSOlzzxdSV3Zfh_SOHovFTxShOBvzqHRko4duo/edit?usp=sharing)

## ~~**User story 1:** As a user, I would like to adjust my account details~~
- Given that the password adjustment feature is implemented correctly, when the user changes their password, their password will be updated in the database
- Given that the email adjustment feature is implemented correctly, when the user changes their email, their email will be updated in the database
- Given that the username adjustment feature is implemented correctly, when the user changes their username, their username will be updated in the database

## ~~**User story 2:** As a user, I would like to be able to clock in~~
- Given that the clock-in feature is implemented correctly, when the user clocks in the clock-in time will be stored correctly in the database
- Given that the clock-in feature is implemented correctly, when the user clocks in, a time-elapsed indicator will begin counting for the shift
- Given that the clock-in feature is implemented correctly, when the user clocks in, they will be able to see their clock-in time

## ~~**User story 3:** As a user, I would like to be able to clock out~~
- Given that the clock-out UI is implemented correctly, when the user clocks out, they will be prompted that they have clocked out
- Given that the clock-out page communications are implemented correctly, when the user clocks out, the clock-out time will be stored in the database
- Given that the clock-out page communications are implemented correctly, when the user clocks out, the shift duration will be calculated and stored in the database

## ~~**User story 4:** As a user, I would like to see my assigned hours in a calendar~~
- Given that the calendar UI is implemented correctly, when the user enters the calendar page, users can see a list of scheduled shifts and other events.
- Given that the shift/event widgets are implemented correctly, when the user enters the calendar, the shift and events should be pulled from the database and displayed
- Given that the calendar screen is implemented correctly, when the user views the calendar page, each shift/event screen will contain information such as shift/event time (and the assignee if applicable)


## ~~**User story 5:** As a user, I would like to be able to accept tasks.~~
- Given that the accept task feature is implemented correctly when the user chooses to accept a task, this task will be added to their tasklist in the database
- Given that the accept task feature is implemented correctly when the user chooses to accept a task, the user will be prompted that s/he accepted the task
- Given that the database is updated correctly, users can see the new assignee on the tasks page for that specific task when the task page is reopened

## ~~**User story 6** As a user, I would like the ability to mark a task as finished.~~
- Given that the ‘complete-task’ feature is implemented correctly, when a user marks a task as finished, the task will be deleted from the task screen
- Given that the ‘complete-task’ feature server communications are correct, when a user marks a task as finishe d, the task will be removed from the database
- Given that the ‘complete-task’ feature server database is correctly updated, when a user marks a task as finished, that task is no longer viewable by users

## ~~**User story 7:** As a user, I would like the ability to see what tasks other users are actively doing.~~
- Given that the task feature is implemented correctly, the user will be able to view the status of each task
- Given that the task feature is implemented correctly, the user will be able to view the user assigned to a task
- Given that the task feature is implemented correctly, the user will be able to view if there are no users assigned to a task

## ~~**User story 8:** As a user, I would like to be able to reset my password if I cannot remember it.~~
- Given that the reset password UI is implemented correctly, the user can navigate to a reset password page from the login page
- Given that the reset password feature is implemented correctly, the user can reset their password by obtaining a ‘reset-code’ sent via their email address (if it exists in the database)
- Given that the updated password is stored correctly in the database, when the user updates their password they can login with their new password

## ~~**User story 9:** As an administrator, I would like the ability to view all users in my team.~~
- Given that backend functionality is implemented correctly, when necessary, a list of users of that specific team will be retrieved.
- Given that the view-users page has good server-communication, when the user enters the view team members page they will see a list of users on their team
- Given that the view-users UI is implemented correctly, when accessing the page, one can see the names of users along with any relevant info (status, etc.)

## ~~**User story 10:** As an administrator, I would like the ability to assign tasks to the task board.~~
- Given that a user is in the tasks page, when clicking on the floating create button, users will be brought to a screen where they can create a task
- Given that the create-task page has good server communication, after creating the task, it be stored in the database
- Given that the create-task page has good server communication, after creating the task, it will be displayed on the tasks page for other users

## ~~**User story 11:** As an administrator, I would like the ability to remove tasks from the task board~~
- Given that the tasks page UI is implemented correctly, by clicking ‘close’ on a task, administrators and users can preemptively remove an uncompleted task
- Given that the ‘close-task’ feature server communications are correct, when a user closes a task, the task will be removed from the tasks page
- Given that the ‘close-task’ feature server database is correctly updated, when a user closes a task, that task is no longer viewable in the tasks page

## ~~**Users story 12:** As an administrator, I would like the ability to send global announcements to the team~~
- If the announcement page is implemented correctly, upon navigating to the create-announcement page, the admin will be able to enter the announcement page and type a message
- If the announcement feature is implemented correctly, upon viewing the home screen, an announcement may be displayed towards the top of the home page
- If the announcement feature is implemented correctly, the administrator will be able to modify or remove an announcement in an appropriate page
  - add a global announcment banner undeerneath user profile pic on main menu

## ~~**User story 13:** As a user, I would like to have the capability of requesting time off~~
- Given the request time-off feature is implemented correctly, when the user requests time off, the admin will be notified about the request
- Given the request time-off feature is implemented correctly, while in the request time-off page, the user will be able to request a period of time to not be assigned work
- Given the request time-off feature is implemented correctly, while in the request time-off page, the user will be able to cancel a request for time off
  - If user makes an event like "time-off, vacay, PTO, etc." in the calendar it will show the user as out of office
  - when they remove the event the time-off request is cancelled

## ~~**User story 14:** As a user, I would like to be able to view my shifts worked for the pay period~~
- Given that the pay-period feature is implemented correctly, when the user enters the page, they can view past shifts
- Given that the pay-period feature is implemented correctly, when the user views passed shifts they will be able to see job hour totals
- Given that pay-period information is stored correctly, while in the pay-period page, users can see the approximate payroll they are expecting
- similar to the task page [justin]

---

# [Sprint Planning 1](https://docs.google.com/document/d/1ktRJKslygew2NhZQAAneP2-CUlr28ZMAGSxfyKaaE9k/edit?usp=sharing)

- ~~future: need to let users switch teams (tracking variables), per Nathan~~

## ~~**User Story 1:** As a user, I would like to register for an account on Shay~~
- Given that the login page is implemented correctly, when the user opens the application, the user will be prompted with a page to enter a username, password, email, and company ID.
- Given that the login page is implemented correctly, when the information matches, the user will be logged in, otherwise, the user will be prompted to retry login
- Given that the new account UI page is implemented correctly and the user is prompted with the create account page, when the company ID matches, the user will be added to the company. 
- Given that the new team UI panel is implemented correctly and the user is prompted with a page to create a new admin account when the admin creates an account, they will see a page that shows the new company ID. 

## ~~**User Story 2:** As a user, I would like to easily reach my clock-in menu~~
- Given that the button to reach clock-in menu is implemented correctly, when the user clicks the button from the main menu to access the clock-in menu the clock-in menu page will appear
- Given that the user is currently clocked in, when the user navigates to the clock-in menu, the current shift’s information should be shown.
- Given that the button to exit the clock-in menu is implemented correctly, when the user clicks the home button from the clock-in menu, they will return to the main menu.

## ~~**User Story 3:** As a user, I would like to be able to clock in~~
- Given that the clock-in logic is correct, when the user clocks in, the users’ current clock-in time will be stored correctly in the database.
- Given that the clock-in UI is implemented correctly, when the user clocks in, they should see a stopwatch begin counting time.
- Given that the database contains the correct clock-in time, when the user visits the clock-in page, their clock-in time should be displayed.

## ~~**User Story 4:** As a user, I would like to adjust my account details~~
- Given that the settings UI is implemented correctly, when the settings UI is opened, the user will be able to enter their updated account info.
- Given that the update account functionality is implemented correctly, when the user saves their information, the user's new details will be stored correctly in the database.
- Given that updated user information is stored correctly, when accessing that user’s account details, the updated version of account info will be provided.

## ~~**User Story 5:** As a user, I would like to be able to clock out~~
- Given that the clock-out button is implemented correctly, when the user navigates to the clock-out menu, the user will be able to see the current job and select to clock-out.
- Given that the user's clock-out time is logged correctly and the clock-out button is implemented correctly, when the user chooses to clock out, the time will be sent to the database.
- Given that the clock-out button is implemented correctly, when the user’s pay/hour information is entered after a shift, learnings will be calculated and stored correctly.

## ~~**User Story 6:** As a user, I would like to be able to view my current shift~~
- Given that the database implementation is correct, when the user selects to view current shift details, data regarding their current shift (start time, end time, time elapsed, tasks assigned, etc.) from the database is retrieved and displayed.
- Given that the current-shift front-end logic is correct and the database stored clock-in time correctly, when the user selects to view current shift details, time elapsed will be calculated and displayed to the user.
- Given that the UI logic is implemented correctly, when the user chooses to clock out, the current shift time elapsed stopwatch no longer updates.

## ~~**User Story 7:** As a user, I would like to be able to reach my calendar easily~~
- Given that the button to access the calendar UI is implemented correctly, when the button is pressed from the main menu, the user will be prompted with a calendar UI. 
- Given that the calendar UI is implemented correctly, when the user enters the calendar page, the user will be able to see a list of dates, tasks assigned to these dates, and hours and tasks that have been worked on previously.
- Given that the calendar screen is implemented correctly, when the user enters the calendar, the shift and events should be pulled from the database and displayed.

## ~~**User Story 8:** As a user, I would like to be able to view the task screen very easily.~~
- Given that the button to access the tasks screen is implemented correctly, when a viewer chooses to view the task board, the user will be shown a to-do list.
- Given that each task component of the page is implemented correctly, when the user chooses to view the task board, the user can see if the task is already in progress and by who.
- Given that user access to each task is implemented correctly, when a user views the tasks board, she can choose to take on a task.

## ~~**User Story 9:** As a user, I would like to be able to accept tasks.~~
- Given that the task accept button is implemented correctly, when the user clicks the button, they will see the accept task button on all jobs that are not in the clock-in list. 
- Given that the task accept button is implemented correctly, when the user clicks the accept task button, it will then add them to the clock-in list.
- Given that the tasks are displayed correctly, when the user accesses their tasks, the task will then be shown as accepted in the database.

## ~~**User Story 10:** As a user, I would like to be able to accept tasks.~~
- Given that the accept task button is implemented correctly, the user will then be able to select a job in their task list as complete.
- Given that the tasks are displayed correctly, the task will then be marked as completed in the database.
- Given that the front-end and back-end connection is implemented correctly, when the user’s task is marked as complete in the database, then the task is removed from the database.

## ~~**User Story 11:** As an administrator, I would like the ability to view all users in my team.~~
- Given that the company member UI is implemented correctly, when the admin chooses to see the user list, they will be able to see all current team members. 
- Given that administrator permissions are implemented correctly, when an administrator wants to edit the status of team members, then they will be able to make status changes that require admin rights.
- Given that the user’s data is stored correctly in the database, when an admin requires access to the data, then the admin will be able to retrieve all of the team’s user data from the database.

## ~~**User Story 12:** As an administrator, I would like the ability to assign tasks to the task board.~~
- Given that the admin UI is implemented correctly, when accessing the admin’s taskboard, the admin will be able to add a task and set permission status.
- Given that the all task board UI is implemented correctly, when the UI for a user without admin permissions is displayed, then the user will not have the ability to add a task or set permission status.
- Given that the task board can be viewed, when tasks are assigned by the admin, then they will be stored in the database.

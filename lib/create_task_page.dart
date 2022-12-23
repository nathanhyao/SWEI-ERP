import 'package:flutter/material.dart';
import 'package:shay_app/services/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Create Task'),
        centerTitle: true,
      ),
      body: Container(
        padding:
            const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            Container(
              height: 350,
              padding: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
              ),
              child: Center(
                child: Image.asset(
                    'assets/images/organizing-todo-list-task-creation.jpg'),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Create New Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 5),
                labelText: 'Task Title',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: ('Organize storage rooms and fridges'),
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate back to task page. Don't save (cancel)
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                    onPressed: () async {
                      if (_titleController.text.isEmpty) {
                        globals.showSnackBar(
                            context, 'Blank Field Not Allowed');
                        return;
                      }

                      http.Response response;
                      try {
                        response = await http.post(
                          Uri.parse(globals.httpURL),
                          body: json.encode(
                            {
                              'key': 'task_create',
                              'title': _titleController.text,
                            },
                          ),
                        );
                      } catch (e) {
                        globals.showSnackBar(
                            context, 'Network Communication Error');
                        return;
                      }

                      if (response.statusCode == 200) {
                        debugPrint('Creating Task: http.post OK');
                        debugPrint('response.body = ${response.body}');

                        // ignore: use_build_context_synchronously
                        globals.showSnackBar(context, 'Task Created');

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop(); // Back to tasks page

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop(); // Back to home screen

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamed('/home/task');
                      } else {
                        debugPrint('Creating Task: http.post BAD');

                        // ignore: use_build_context_synchronously
                        globals.showSnackBar(
                            context, 'Server Communication Error');
                      }
                    },
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

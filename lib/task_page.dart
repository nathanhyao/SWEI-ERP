import 'package:flutter/material.dart';
import 'package:shay_app/models/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shay_app/services/globals.dart' as globals;

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<Task> _tasks = [];

  Future fetchTasks() async {
    http.Response response;
    try {
      debugPrint('Fetching Tasks');
      response = await http.post(
        Uri.parse(globals.httpURL),
        body: json.encode(
          {
            'key': 'task_fetch',
            'teamID': globals.currentTeam.teamID,
          },
        ),
      );
      // debugPrint(response.body);
    } catch (e) {
      globals.showSnackBar(context, 'Network Communication Error');
      return;
    }

    // Parse into Task objects, store into 'tasks' list
    var tasks = <Task>[];

    if (response.statusCode == 200) {
      // http returns 200 means OK
      debugPrint('Fetching Tasks: http.get OK');

      var tasksJson = json.decode(response.body);
      for (var taskJson in tasksJson) {
        tasks.add(Task.fromJson(taskJson));
      }
    } else {
      debugPrint('Fetching Tasks: http.get BAD');
    }

    return tasks;
  }

  @override
  void initState() {
    fetchTasks().then((value) {
      // fetchTasks() is asynchronous. Use .then() to wait for it to finish
      setState(() {
        _tasks.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/home/task/create');
        },
        backgroundColor: Colors.orange,
        tooltip: 'Create New Task',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 1,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.orange,
        title: const Text('Task Board'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  fetchTasks().then((value) {
                    setState(
                      () {
                        _tasks.clear();
                        _tasks.addAll(value);
                      },
                    );
                  });
                });
              },
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemBuilder: (context, index) {
            var title = _tasks[index].title;
            var isInProgress = _tasks[index].isInProgress;
            var assignedName = _tasks[index].assignedName;

            return Card(
              elevation: 2.5,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.assignment,
                        size: 35,
                      ),
                      title: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(isInProgress),
                          Text('Assigned to $assignedName'),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          child: const Text(
                            'Self-Assign Task',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 136, 0),
                            ),
                          ),
                          onPressed: () async {
                            http.Response response;
                            try {
                              // http to server to update task assignment
                              response = await http.post(
                                Uri.parse(globals.httpURL),
                                body: json.encode(
                                  {
                                    'key': 'task_accept',
                                    'title': title,
                                    'name': globals.currentUser.name,
                                  },
                                ),
                              );
                              debugPrint('response.body = ${response.body}');
                            } catch (e) {
                              globals.showSnackBar(
                                  context, 'Network Communication Error');
                              return;
                            }

                            // updating the in-progress status for this task
                            // this may be incorrect
                            // _tasks[index].isInProgress = true;
                            isInProgress = _tasks[index].isInProgress;

                            if (response.statusCode == 200) {
                              debugPrint('Creating Task: http.post OK');

                              // ignore: use_build_context_synchronously
                              globals.showSnackBar(
                                  context, 'Task Assigned to You');
                            } else {
                              debugPrint('Creating Task: http.post BAD');

                              // ignore: use_build_context_synchronously
                              globals.showSnackBar(
                                  context, 'Server Communication Error');
                              return;
                            }

                            setState(() {
                              fetchTasks().then((value) {
                                setState(() {
                                  _tasks.clear();
                                  _tasks.addAll(value);
                                });
                              });
                            });
                          },
                        ),
                        const SizedBox(width: 20),
                        OutlinedButton(
                          child: const Text(
                            'Mark Complete',
                            style: TextStyle(color: Colors.green),
                          ),
                          onPressed: () async {
                            http.Response response;
                            try {
                              response = await http.post(
                                Uri.parse(globals.httpURL),
                                body: json.encode(
                                  {
                                    'key': 'task_delete',
                                    'title': title,
                                  },
                                ),
                              );
                              debugPrint('response.body = ${response.body}');
                            } catch (e) {
                              globals.showSnackBar(
                                  context, 'Network Communication Error');
                              return;
                            }

                            if (response.statusCode == 200) {
                              debugPrint('Creating Task: http.post OK');

                              // ignore: use_build_context_synchronously
                              globals.showSnackBar(context, 'Task Closed');
                            } else {
                              debugPrint('Creating Task: http.post BAD');

                              // ignore: use_build_context_synchronously
                              globals.showSnackBar(
                                  context, 'Server Communication Error');
                            }

                            setState(() {
                              fetchTasks().then((value) {
                                setState(() {
                                  _tasks.clear();
                                  _tasks.addAll(value);
                                });
                              });
                            });
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: _tasks.length,
        ),
      ),
    );
  }
}

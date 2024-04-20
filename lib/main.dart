import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Tasks'),
            );
          } else {
            List<Widget> ongoingTasks = [];
            List<Widget> completedTasks = [];

            snapshot.data!.docs.forEach((doc) {
              Timestamp createdAtTimestamp = doc['created_at'] ?? Timestamp.now();
              DateTime createdAt = createdAtTimestamp.toDate();
              String formattedDate = '${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute}';

              ListTile taskTile = ListTile(
                title: Text(doc['name']),
                subtitle: Text('Created at: $formattedDate'),
                leading: Checkbox(
                  value: doc['status'] == 'done',
                  onChanged: (value) async {
                    if (value != null) {
                      await FirebaseFirestore.instance.collection('tasks').doc(doc.id).update({
                        'status': value ? 'done' : 'to-do',
                      });
                    }
                  },
                ),
                onLongPress: () async {
                  await FirebaseFirestore.instance.collection('tasks').doc(doc.id).delete();
                },
              );

              if (doc['status'] == 'done') {
                completedTasks.add(taskTile);
              } else {
                ongoingTasks.add(taskTile);
              }
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ongoing Tasks:', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView(
                    children: ongoingTasks,
                  ),
                ),
                SizedBox(height: 16),
                Text('Completed Tasks:', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView(
                    children: completedTasks,
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController _controller = TextEditingController();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Task'),
                content: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Task Name'),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      String taskName = _controller.text;
                      if (taskName.isNotEmpty) {
                        await FirebaseFirestore.instance.collection('tasks').add({
                          'name': taskName,
                          'status': 'to-do', // default status
                          'created_at': FieldValue.serverTimestamp(), // add server timestamp
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

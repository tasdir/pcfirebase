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
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return ListTile(
                  title: Text(doc['name']),
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
              }).toList(),
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

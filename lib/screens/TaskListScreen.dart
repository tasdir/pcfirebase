import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              child: Text('No Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            );
          } else {
            List<Widget> ongoingTasks = [];
            List<Widget> completedTasks = [];

            snapshot.data!.docs.forEach((doc) {
              Timestamp createdAtTimestamp = doc['created_at'] ?? Timestamp.now();
              DateTime createdAt = createdAtTimestamp.toDate();
              String formattedDate = '${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute}';

              ListTile taskTile = ListTile(
                title: Text(
                  doc['name'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Created at: $formattedDate',
                  style: TextStyle(color: Colors.grey),
                ),
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
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Update Task'),
// Inside your ListTile's onTap method
                              onTap: () async {
                                TextEditingController _controller = TextEditingController(text: doc['name']);
                                String updatedTaskName = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Update Task'),
                                      content: TextField(
                                        controller: _controller,
                                        autofocus: true,
                                        decoration: InputDecoration(labelText: 'New Task Name'),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, null);
                                          },
                                          child: Text('Cancel', style: TextStyle(color: Colors.red)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            String updatedName = _controller.text;
                                            Navigator.pop(context, updatedName);
                                          },
                                          child: Text('Update', style: TextStyle(color: Colors.green)),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (updatedTaskName != null) {
                                  await FirebaseFirestore.instance.collection('tasks').doc(doc.id).update({
                                    'name': updatedTaskName,
                                  });
                                }
                              },

                            ),
                            ListTile(
                              leading: Icon(Icons.notifications),
                              title: Text('Set Notification'),
                              onTap: () {
                                // Implement set notification functionality here



                                Navigator.pop(context); // Close the bottom sheet after selection
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete Task'),
                              onTap: () {
                                // Implement delete task functionality here
                                Navigator.pop(context); // Close the bottom sheet after selection
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Ongoing Tasks:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: ongoingTasks,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Completed Tasks:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                  ),
                ),
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
                    child: Text('Cancel', style: TextStyle(color: Colors.red)),
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
                    child: Text('OK', style: TextStyle(color: Colors.green)),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskActionSheet extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final BuildContext parentContext;

  TaskActionSheet({required this.doc, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Update Task'),
            onTap: () async {
              TextEditingController _controller = TextEditingController(text: doc['name']);
              String? updatedTaskName = await showDialog<String>(
                context: parentContext,
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
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: TextStyle(color: Colors.red)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, _controller.text),
                        child: Text('Update', style: TextStyle(color: Colors.green)),
                      ),
                    ],
                  );
                },
              );

              if (updatedTaskName != null && updatedTaskName.isNotEmpty) {
                await FirebaseFirestore.instance.collection('tasks').doc(doc.id).update({
                  'name': updatedTaskName,
                });
                Navigator.pop(parentContext); // Close the bottom sheet
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Set Notification'),
            onTap: () {
              // Implement set notification functionality here
              Navigator.pop(parentContext); // Close the bottom sheet
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Task'),
            onTap: () async {
              await FirebaseFirestore.instance.collection('tasks').doc(doc.id).delete();
              Navigator.pop(parentContext); // Close the bottom sheet
            },
          ),
        ],
      ),
    );
  }
}

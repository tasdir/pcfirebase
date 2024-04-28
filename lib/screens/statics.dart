import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'UserProfilePage.dart';

class Statics extends StatelessWidget {
  const Statics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Statics'),
      ),
      body: StreamBuilder<QuerySnapshot?>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            var countComplete = 0;
            var countOngoing = 0;

            snapshot.data!.docs.forEach((doc) {
              if (doc['status'] == 'done') {
                countComplete++;
              } else {
                countOngoing++;
              }
            });

            return Column(
              children: [
                if (countComplete > 0) ...[
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red.withOpacity(0.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Completed Tasks',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${countComplete}',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
                if (countOngoing > 0) ...[
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.withOpacity(0.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ongoing Tasks',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${countOngoing}',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          }
        },
      ),
    );
  }
}
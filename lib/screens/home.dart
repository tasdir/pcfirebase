import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final firebase = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter and Firebase'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.red,
      ),

         body: StreamBuilder(
           stream : firebase.collection('newdata').snapshots() ,
           builder: (context,AsyncSnapshot snapshot){
             print(snapshot.data!.docs[0]['time']);

             return ListView.builder(
               itemCount: snapshot.data!.docs.length,
               itemBuilder: (context, index){
                 return Card(
                   color: Colors.cyan,

                   child: Column (
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(snapshot.data!.docs[0]['message'])
                     ],
                   ),
                 );
               },
             );
           },

         ),



      // body: StreamBuilder(
      //   stream: firebase.collection('new').snapshots(),
      //   builder: ,
      // ),


      // body: StreamBuilder(
      //   stream: firebase.collection('new').snapshots(),
      //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.hasData) {
      //       return ListView.builder(
      //         itemCount: snapshot.data!.docs.length,
      //         itemBuilder: (context, index) {
      //           return Card(
      //             child: Column(
      //               children: [
      //                 Text(snapshot.data!.docs[index]['message']),
      //                 Text(snapshot.data!.docs[index]['time'].toString()),
      //               ],
      //             ),
      //           );
      //         },
      //       );
      //     } else {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          firebase.collection('newdata').doc(Timestamp.now().toString()).set({


            // firebase.collection('new').add({
            'message': 'hello1',
            'time': Timestamp.now(),
          });
        },
        backgroundColor: Colors.cyan,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

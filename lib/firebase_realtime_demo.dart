import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRealtimeDemoScreen extends StatelessWidget {

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  FirebaseRealtimeDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //readData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Database Demo'),
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                RaisedButton(
                  child: const Text('Create Data'),
                  color: Colors.redAccent,
                  onPressed: () {
                    createData();
                  },
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                const SizedBox(height: 8,),
                RaisedButton(
                  child: const Text('Read/View Data'),
                  color: Colors.redAccent,

                  onPressed: () async {
                    await readData();
                  },
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                ),
                const SizedBox(height: 8,),

                RaisedButton(
                  child: const Text('Update Data'),
                  color: Colors.redAccent,

                  onPressed: () {
                    updateData();
                  },
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                ),
                const SizedBox(height: 8,),

                RaisedButton(
                  child: const Text('Delete Data'),
                  color: Colors.redAccent,

                  onPressed: () {
                    deleteData();
                  },
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                ),
              ],
            ),
          )
      ), //center
    );
  }

  void createData(){
    databaseReference.child("flutterDevsTeam1").set({
      'name': 'Deepak Nishad',
      'description': 'Team Lead'
    });
    databaseReference.child("flutterDevsTeam2").set({
      'name': 'Yashwant Kumar',
      'description': 'Senior Software Engineer'
    });
    databaseReference.child("flutterDevsTeam3").set({
      'name': 'Akshay',
      'description': 'Software Engineer'
    });
    databaseReference.child("flutterDevsTeam4").set({
      'name': 'Aditya',
      'description': 'Software Engineer'
    });
    databaseReference.child("flutterDevsTeam5").set({
      'name': 'Shaiq',
      'description': 'Associate Software Engineer'
    });
    databaseReference.child("flutterDevsTeam6").set({
      'name': 'Mohit',
      'description': 'Associate Software Engineer'
    });
    databaseReference.child("flutterDevsTeam7").set({
      'name': 'Naveen',
      'description': 'Associate Software Engineer'
    });

  }
  Future<void> readData() async {
    DataSnapshot snapshot = await databaseReference.get();
    print('readData1 : ${snapshot.value}');


    final event = await databaseReference.once(DatabaseEventType.value);
    print('readData2: ${event.snapshot.value}');
    // databaseReference.once().then((DataSnapshot snapshot) {
    //   print('Data : ${snapshot.value}');
    // });
  }

  void updateData(){
    databaseReference.child('flutterDevsTeam1').update({
      'description': 'CEO'
    });
    databaseReference.child('flutterDevsTeam2').update({
      'description': 'Team Lead'
    });
    databaseReference.child('flutterDevsTeam3').update({
      'description': 'Senior Software Engineer'
    });
  }

  void deleteData(){
    databaseReference.child('flutterDevsTeam1').remove();
    databaseReference.child('flutterDevsTeam2').remove();
    databaseReference.child('flutterDevsTeam3').remove();
  }
}
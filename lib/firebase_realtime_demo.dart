import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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

                ElevatedButton(
                  child: const Text('Create Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    // elevation: 5,
                    // padding: const EdgeInsets.all(12.0),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  onPressed: () {
                    createData();
                  },
                ),
                const SizedBox(height: 8,),
                ElevatedButton(
                  child: const Text('Read/View Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    // elevation: 5,
                    // padding: const EdgeInsets.all(12.0),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),

                  onPressed: () async {
                    await readData();
                  },
                ),
                const SizedBox(height: 8,),

                ElevatedButton(
                  child: const Text('Update Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    // elevation: 5,
                    // padding: const EdgeInsets.all(12.0),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  onPressed: () {
                    updateData();
                  },
                ),
                const SizedBox(height: 8,),

                ElevatedButton(
                  child: const Text('Delete Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    // elevation: 5,
                    // padding: const EdgeInsets.all(12.0),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  onPressed: () {
                    deleteData();
                  },
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
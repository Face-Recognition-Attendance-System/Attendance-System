import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

  class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final Stream<QuerySnapshot> user = FirebaseFirestore.instance.collection('users').snapshots();

  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;

  logOut() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return StreamBuilder<QuerySnapshot>(
      stream: user,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          print('Something went wrong');
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document ) {
          Map a = document.data() as Map<String, dynamic>;
          a["docID"] = document.id;
          if(a["docID"] == uid){
            storedocs.add(a);
          }
        }).toList();

        String time = storedocs[0]["time"];
        String date = storedocs[0]["date"];
        String status = storedocs[0]["status"];

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'DASHBOARD',
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'ATTENDANCE STATUS',
                    style: TextStyle(
                      fontSize: 30.0
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 100.0),
                    child: Table(
                      border: TableBorder.all(),
                      columnWidths: const <int, TableColumnWidth>{
                        1: FixedColumnWidth(200.0),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                color: Colors.greenAccent,
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                color: Colors.greenAccent,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      status,
                                      style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]
                        ),

                        TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  color: Colors.greenAccent,
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        'Time',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  color: Colors.greenAccent,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        time,
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]
                        ),

                        TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  color: Colors.greenAccent,
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        'Date',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  color: Colors.greenAccent,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        date,
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


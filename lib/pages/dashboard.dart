import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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

        String name = storedocs[0]["Name"];
        int age = storedocs[0]["Age"];
        String image = storedocs[0]["Image"];
        String time = storedocs[0]["time"];
        String date = storedocs[0]["date"];
        String status = storedocs[0]["status"];
        String email = storedocs[0]["email"];

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'DASHBOARD',
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),

                   CircleAvatar(
                    radius: 75.0,
                    backgroundImage: NetworkImage(image),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20.0
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  Text(
                    email,
                    style: const TextStyle(
                        fontSize: 20.0
                    ),
                  ),

                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: [
                        Container(
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                Navigator.pushNamed(context, 'calendar');
                              });;
                            },
                            child: const Icon(
                              Icons.calendar_today_outlined,
                              size: 150.0,
                            ),
                          ),
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                Navigator.pushNamed(context, 'settings');
                                // print(email);
                              });
                            },
                            child: const Icon(
                              Icons.history,
                              size: 150.0,
                            ),
                          ),
                        )
                      ],
                    )
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            logOut();
                          },
                          child: const Text('LogOut'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

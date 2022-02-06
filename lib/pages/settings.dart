import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {

  final Stream<QuerySnapshot> sta = FirebaseFirestore.instance.collection('users').snapshots();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;

  List<Widget> mylist = [];
  String absent = 'ABSENT';
  String present = 'PRESENT';

  CalendarFormat format = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String month = selectedDay.month.toString();
    String day = selectedDay.toString();
    CollectionReference stat = FirebaseFirestore.instance.collection('users').doc(uid).collection(month);



    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection(month)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          print('Something went wrong');
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedoc = [];
        snapshot.data!.docs.map((DocumentSnapshot document ) {
          Map a = document.data() as Map<String, dynamic>;
          storedoc.add(a);
        }).toList();

        String statuse = storedoc[selectedDay.day-1]["status"];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Calendar ',
            ),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TableCalendar(
                    focusedDay: focusedDay,
                    firstDay: DateTime(2021),
                    lastDay: DateTime(2050),
                    calendarFormat: format,
                    onFormatChanged: (CalendarFormat _format){
                      setState(() {
                        format = _format;
                      });
                    },
                    daysOfWeekVisible: true,
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted : true,

                      selectedDecoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle
                      ),

                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    selectedDayPredicate: (DateTime Date){
                      return isSameDay(selectedDay, Date);
                    },

                    onDaySelected: (DateTime selectDay, DateTime focusDay){
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                        print(storedoc);
                        mylist = [];
                        mylist.add(
                            Container(
                              child: Text(
                                  statuse
                              ),
                            )
                        );
                      });
                    },
                  ),
                ),

                Expanded(
                  child: Column(
                    children: mylist,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;

  logOut() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'DASHBOARD'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Hello $uid, your email is $email',
            ),
            SizedBox(
              height: 25.0,
            ),
            ElevatedButton(
              onPressed: (){
                logOut();
              },
              child: Text('LogOut'),
            )
          ],
        ),
      ),
    );
  }
}

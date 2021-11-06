import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/login_page.dart';
import 'pages/dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AttendanceApp());
}

class AttendanceApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print('Something Went Wrong');
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return MaterialApp(
            routes: {
              'login' : (context) => Login(),
              'dashboard': (context) => const Dashboard(),
            },
            theme: ThemeData.dark(),
            home: Login(),
          );
        }
    );
  }
}

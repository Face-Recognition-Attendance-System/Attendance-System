import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/login_page.dart';
import 'pages/dashboard.dart';
import 'pages/calendar.dart';
import 'pages/settings.dart';

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
              'calendar' : (context) => Calendar(),
              'settings' : (context) => Settings()
            },
            theme: ThemeData.dark().copyWith(
                primaryColor: const Color(0xFF0A0E21),
                scaffoldBackgroundColor : const Color(0xFF0A0E21)
            ),
            home: Login(),
          );
        }
    );
  }
}

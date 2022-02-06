import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  var email = "";
  var pass = "";
  final emailController = TextEditingController();
  final passController = TextEditingController();

  userLogin() async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
      Navigator.pushNamed(context, 'dashboard');
    }on FirebaseAuthException catch(e) {
      if(e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'NO USER FOUND',
                  style: TextStyle(
                    color: Colors.black,
              fontSize: 18.0,
            ),
            ),
          )
        );
      }
      else if(e.code == 'wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'WRONG PASSWORD ENTERED',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black
              ),
            ),
          ),
        );
      }
    }
  }

  @override

  void dispose(){
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'LOGIN PAGE'
        ),
        backgroundColor: const Color(0xFF0A0E21),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(25.0, 200.0, 25.0, 10.0),
              child: TextFormField(
                autofocus: false,
                decoration: const InputDecoration(
                    labelText: 'Email: ',
                    labelStyle: TextStyle(
                        fontSize: 20.0
                    ),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15.0,
                    )
                ),
                controller: emailController,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please enter email';
                  }
                  else if(!value.contains('@')){
                    return 'Please enter a valid Email';
                  }
                },
              ),
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
              child: TextFormField(
                autofocus: false,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password: ',
                    labelStyle: TextStyle(
                        fontSize: 20.0
                    ),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15.0,
                    )
                ),
                controller: passController,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please enter password';
                  }
                },
              ),
            ),

            Center(
              child: ElevatedButton(
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                  setState(() {
                  email = emailController.text;
                  pass = passController.text;
                  });
                  userLogin();
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20.0
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFEB1555)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:companion_beta/authentication.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companion_beta/main.dart';


class SplashPage extends StatefulWidget {
  SplashPage();
  @override
  State createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
final FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  void initState() {
    super.initState();

    // Listen for our auth event (on reload or start)
    // Go to our /todos page once logged in
    _auth.onAuthStateChanged
        .firstWhere((user) => user != null)
        .then((user) {
          Firestore.instance.collection("answers").document(user.uid).setData({"uid":user.uid,
          "answered" :false,
          "value":false,
          "notDone1":true,
          "notDone2":true,
          });
      Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MyHomePage(uid:user.uid)));
    });

    // Give the navigation animations, etc, some time to finish
    new Future.delayed(new Duration(seconds: 1))
        .then((_) => signInWithGoogle());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new CircularProgressIndicator(),
              new SizedBox(width: 20.0),
              new Text("Please wait..."),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget{
  Dashboard();

@override
DashboardState createState()=> DashboardState();
}

class DashboardState extends State<Dashboard>{
  int progress;bool show=true; 
  String userId;
  FirebaseUser user; FirebaseAuth auth=FirebaseAuth.instance;
  DocumentSnapshot document;
  
  DocumentReference ansRef;

  void getUser() async{
    var user1= await auth.currentUser();
    user=user1;
    userId=user.uid;
  }
  
  @override
  void initState(){
    getUser();
    ansRef=Firestore.instance.collection("answers").document(userId);
    super.initState();
    getDocument();
    updateProgress();
  }
  
  void getDocument() async{
    document=await ansRef.get();
  }

  void updateProgress(){
    progress=document['q1']-document['q1old'];
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
          Flexible(
            child:(!show)? Container():
            Column(
              children:<Widget>[
                (progress>0)?
              ListTile(
                leading: Image.asset("community"),
                title: Text("Congratulations!", style:TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("You met $progress more people today. Keep it going."),
              ):
              ListTile(
                leading: Image.asset("encourage"),
                title: Text("You are yet to make progress"),
              ) ,
               
            
            ButtonTheme.bar( // makes buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Share'),
                  onPressed: () { 
                    //TODO Implement share to social media
                   },
                ),
                FlatButton(
                  child: const Text('Dismiss'),
                  onPressed: () { 
                    setState(() {
                     show=false;
                    });
                   },
                ),
              ],
            ),
          )
          ],
         ),
        
      )]);
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:companion_beta/Questions.dart';



class Tasks extends StatefulWidget{
  Tasks({this.uid:""});
final String uid;
@override
TasksState createState()=> TasksState(uid);
}

class TasksState extends State<Tasks>{

  var now=DateTime.now();
  bool timeUp=true;
  TasksState(this.userId);

  Map<String,dynamic> identifiers =Map.from({
  "answered" :false,
  "value":false,
  "notDone1":true,
  "notDone2":true,
  "defNumber":-1,
  "hour":null
  }) ;
   FirebaseAuth auth=FirebaseAuth.instance;
 

  
  String userId;
  DocumentReference ansRef;
  
  Future<void> configure() async{
    final FirebaseApp app=await FirebaseApp.configure(
    name: 'companionbeta',
    options: const FirebaseOptions(
      googleAppID: '1:933028870179:android:ede06df604d42475',
      apiKey: 'AIzaSyCdSfHQoXvBPNyBd-NtXO4RB3MVB-gUE6A ',
      projectID: 'companionbeta'
    )
    );
    final Firestore firestore=Firestore(app: app);
    await firestore.settings(timestampsInSnapshotsEnabled: true);
  }

  bool isDepressed(DocumentSnapshot document){
    
    document.data.putIfAbsent("q1",document["defNumber"]);
    if(document["q1"]<3)
    return true;
    return false;
  }
  
  @override
  void initState(){
    configure();
    ansRef=Firestore.instance.collection("answers").document(userId);
    addData();
    super.initState();
  }

  void updateTime(DocumentSnapshot document)async{
    
    if(document["hour"]==null)
    await document.reference.updateData({
      "hour":now.hour
    });
    assert(now.hour!=null);
    if( document["hour"] <24){
      setState(() {
        timeUp=true;
      });
      await  document.reference.updateData({
         "hour":document["hour"]+24
      });
    }
        
  }
  
  void addData() async{
    ansRef.get().then((DocumentSnapshot ds){
     ds.data.addAll(identifiers);
     updateTime(ds);
     isDepressed(ds);
    });
   
  }
  

  @override
  Widget build(BuildContext context){
   
    return Material(
    
      
    child: StreamBuilder(
          stream: Firestore.instance.collection("answers").snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) return Text("Loading..");
            DocumentSnapshot doc=snapshot.data.documents[0];
            Map<String,bool> check =Map.from({
              "answered" :(doc["answered"]==null)? false:true,
              "notDone1" :(doc["notDone1"]==null)? false:true,
              "notDone2" :(doc["notDone2"]==null)? false:true,
              "q1": (doc["q1"]==null)? false:true,
            });
            return builder(context,doc, check);
          })
      );
      
  }

  Widget builder(BuildContext context, DocumentSnapshot document, Map<String,bool> check){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[   
      (check["answered"] && timeUp &&!document["answered"]) ? askQuestion(document) : Container(),
        Flexible(child:Card(child:ListView(
          children: <Widget>[
            (check["notDone1"] && check["q1"] && isDepressed(document) && document["notDone1"])? 
            ListTile(
              contentPadding: EdgeInsets.all(10.0),
              leading: Icon(Icons.people),
              title: Text("Meet more people") ,
              subtitle: Text("uno dos tres"),
              trailing: Checkbox(
                value:false,
                onChanged: (value){
                  setState(() {
                   if(value)
                   document.reference.updateData({
                     "notDone1": false
                   });
                  });
                },
              ),
            ):Container(),
            (check["notDone2"] && check["q1"] && isDepressed(document) && document["notDone2"])? 
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal:10.0),
              leading: Icon(Icons.library_music),
              title: Text("Listen to tunes") ,
              subtitle: Text("uno dos tres"),
              trailing: Checkbox(
                value: document["value"],
                onChanged: (value){
                  setState(() {
                   if(value)
                   document.reference.updateData({
                     "notDone2":false
                   });
                  });
                },
              ),
            ):Container(),
            (check["q1"] && check["notDone1"] && isDepressed(document) && !document["notDone1"])?
            Card(
              child: Expanded(
                child: Text("Yay! We are happy today"),
              )
            ):Container()
          ],
        ),
        elevation: 2.0,
        margin: EdgeInsets.symmetric(horizontal:12.0,vertical: 6.0),
    )
    )
    ]
    );
  }

  Widget askQuestion(DocumentSnapshot document){
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('Ready to answer a few questions?'),
            subtitle: Text('It will only take a minute'),
          ),
          ButtonTheme.bar( // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Yes!'),
                  onPressed: () { 
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Questions(document)));
                   },
                ),
                FlatButton(
                  child: const Text('Not now'),
                  onPressed: () { 
                    setState(() {
                     document.reference.updateData({
                       "answered":true
                     });
                    });
                   },
                ),
              ],
            ),
          ),
        ],
      ),
      elevation: 2.0,
      margin: EdgeInsets.all(12.0),
    );
  }
}
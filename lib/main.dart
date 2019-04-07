import 'package:flutter/material.dart';
import 'CustomTabBar.dart';
import "Screens/Tasks.dart";
import 'Screens/Dashboard.dart';
import 'Screens/AccountPage.dart';
import 'Screens/DoctorPage.dart';
import 'Screens/SplashPage.dart';
import 'authentication.dart';




void main() =>runApp(MyApp());


class MyApp extends StatelessWidget {
  final String uid;
  MyApp({this.uid=""});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: SplashPage(),
      routes: 
      {
        "tasks":(context)=>Tasks(uid: uid),
        
        "main" :(context)=>MyHomePage(uid:uid),
        "doctor": (context)=>DoctorPage(),
        "account": (context)=>AccountPage(),
      },
      title: 'companion',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String uid;
  MyHomePage({Key key, this.uid}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title="Your Companion";

  @override
  _MyHomePageState createState() => _MyHomePageState(uid:uid);
}

class _MyHomePageState extends State<MyHomePage> {
PageController pageController=PageController(initialPage: 0);
_MyHomePageState({this.uid});
String uid;

Map<String,Widget> pages;
@override
void initState(){
pages=<String,Widget>{
    "Tasks" : Tasks(uid:uid),
    "Dashboard" : Dashboard(),   
  };
  super.initState();
}

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor:
        Colors.deepOrange,
        title: Text(
          widget.title,
          textAlign: TextAlign.left,
          style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold)
          ),
          
        bottom: CustomTabBar(pageController: pageController, pageNames: pages.keys.toList(),),
      ),
      drawer: Drawer(
        elevation: 16.0,
        child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin:EdgeInsets.all(10.0) ,
            child: Text.rich(TextSpan(text: "JAYESH")),
          ),
        ListTile(
        leading: Image.asset("doctor"),  
        title: Text('Get Professional Help',
          style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.normal),),
        onTap: () {
        Navigator.pushNamed(context, "doctor");
        Navigator.pop(context);
        },
        ),
        ListTile(
        leading: Image.asset("Account"),  
        title: Text('Your Account',
        style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.normal),),
        onTap: () {
        Navigator.pushNamed(context, "account");
        Navigator.pop(context);
        },),
        ListTile(
              title: new Text('Logout', textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.normal),),
              trailing: new Icon(Icons.exit_to_app),
              onTap: () async {
                await signOutWithGoogle();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
        ]
        )
      ),
      body: 
        PageView(
        controller: pageController,
        children: pages.values.toList(),
        )
      
    );
      
  }
}

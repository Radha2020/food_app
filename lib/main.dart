import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food/auth/login.dart';
import 'package:food/auth/registration.dart';
import 'package:food/page/kot.dart';
import 'package:food/database_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
void main()
{ runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => MyApp(),
    '/second': (context) => SecondPage(),
    '/home':    (context) => MyApp(),
    '/login':(context)=>LoginPage(),
    '/register':(context)=>SecondPage(),
    '/kot': (context)=>KotPage(),

  },
));
}

class MyApp extends StatefulWidget {

  @override
  _State createState() => _State();
}
class _State extends State<MyApp>  {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  final dbHelper = DatabaseHelper.instance;
  String _message='';
  String username='';
  String email='';
  void initState() {
    super.initState();
    getMessage();
    _getcred();
  }
  void getMessage(){
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));




          //      print('on message $message');
          //        setState(() => _message = message["notification"]["title"]);
//print(_message);
        },
        onResume: (Map<String, dynamic> message) async {

          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));



//          print('on resume $message');
          //    setState(() => _message = message["notification"]["title"]);
          //  print(_message);
        },
        onLaunch: (Map<String, dynamic> message) async {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));




          //print('on launch $message');
          //setState(() => _message = message["notification"]["title"]);
          // print(_message);
        }

    );
  }




  _getcred() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //log=(prefs.getBool('login'));
      username = (prefs.getString('name'));
      print(username);
      email=(prefs.getString('email'));
      print(email);
      if(username==null ) {
        Navigator.push(context,MaterialPageRoute(builder:(context)=>LoginPage()));

      }

    });
  }
  _closecred() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('name');
      prefs.remove('password');
      prefs.remove('waiterno');
      prefs.remove('waitername');
      dbHelper.deleteall();
      dbHelper.deletetable();
    });

  }
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit an App'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () =>exit(0),
            //Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        //return new Future(() => false);


        child:Scaffold(backgroundColor: Colors.white,
          appBar: AppBar(title: Text("ABC Restaurant"),backgroundColor:Colors.orange,),
          body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/image.jpg"), fit: BoxFit.cover),
              )),
          drawer: Drawer(
              child:Container(
                color:Colors.orange,
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.only(top:30.00),

                  children: <Widget>[
                    //  Container(
                    //  height:40.0,
                    // child:UserAccountsDrawerHeader(

                    //  accountName:Text('$username'),

                    //     accountEmail: Text("abc@impel.com"),
                    // currentAccountPicture: CircleAvatar(child:Text("IH",),
                    // backgroundColor:Colors.white),
                    // )),
                    ListTile(
                      title:Text('$username',
                          style: TextStyle(color:Colors.black)),
                      subtitle:Text('$email',
                          style:TextStyle(color:Colors.black)),

                    ),

                    new Divider(
                        color: Colors.black,
                        thickness:2
                    ),

                    ListTile(
                      leading:Icon(Icons.home,
                          color:Colors.white),
                      title:Text('Home',
                          style:TextStyle(color:Colors.white,fontSize:17)),
                      onTap:() {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile( leading:Icon(Icons.fastfood,color:Colors.white),
                      title: Text('Kitchen Order',style:TextStyle(color:Colors.white,fontSize:17)),

                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.push(context,MaterialPageRoute(builder:(context)=>KotPage()));
                        // Navigator.push(context,MaterialPageRoute(builder:(context)=>TestPage()));

                      },

                    ),
                    ListTile(
                      leading:Icon(Icons.donut_small,color:Colors.white),
                      title: Text('parcel',style:TextStyle(color:Colors.white,fontSize:17)),
                      onTap: () {               // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                        leading:Icon(Icons.people_outline,color:Colors.white),
                        title:Text('Register',style:TextStyle(color:Colors.white,fontSize:17)),
                        onTap: (){

                          Navigator.push(context,MaterialPageRoute(builder:(context)=>SecondPage()));
                        }
                    ),
                    ListTile(
                        leading:Icon(Icons.close,color:Colors.white),
                        title:Text('LogOut',style:TextStyle(color:Colors.white,fontSize:17)),
                        onTap: (){
                          _closecred();
                          Navigator.push(context,MaterialPageRoute(builder:(context)=>LoginPage()));
                        }
                    )


                  ],
                ),
              )),
        ));
  }
}
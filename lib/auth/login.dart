import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food/auth/registration.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:food/main.dart';
import 'dart:async';
import 'dart:convert';

Future<String> addLocal(n,p) async {

  await new Future.delayed(const Duration(seconds: 5));

  _LoginDataJson logindatajson=_LoginDataJson(n,p);
  String jsonUser=jsonEncode(logindatajson);
  print(jsonUser);

// set up POST request arguments
  String url = 'http://hospital.impelcreations.co.in/hosp/Api/flutcheck';
//  String url = 'http://192.168.43.63/hosp/Api/flutcheck';
  Map<String, String> headers = {"Content-type": "application/json"};
  try{
    http.Response response = await http.post(url, headers: headers, body: jsonUser);
    print(response.statusCode);
    print(response.body.toString());

    var  data=jsonDecode(response.body);
    String status=data["status"];
    String msg=data["message"];
    String name=data["name"];
    if(status=="valid"){

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
      prefs.setString('email',n);
      prefs.setString('password', p);
      return msg;
    }
  }
  catch(err){
    print('Caught error: $err');
    return err;
  }

}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}


class LoginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

Future<void>_displayResponse(context,res) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Welcome'),
          content:Text('$res'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

class _LoginData {

  String email = '';
  String password = '';
}

class _LoginDataJson{
  String email = '';
  String password = '';
  _LoginDataJson(this.email,this.password);

  Map toJson() => {
    'email': email,
    'password':password
  };


}

class _State extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },


        child: Scaffold(
            body:
            //Center(
            Container(
                height:420.0,
                padding:EdgeInsets.only(top:40.0,left:20.0,right:20.0),

                child:new Form(
                    key: _formKey,
                    // child:Container(
                    child:Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation:10.0,
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            leading:Padding(
                              padding: const EdgeInsets.all(10.0),
                              //child: Image.asset(
                              // "assets/logo.png",
                              //  ),
                            ),
                            title: Text('SIGN IN',style:TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 25


                            )),
                            //  subtitle: Text('Welcome'),
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),

                              child:TextFormField(
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.email),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(color: Colors.blue)),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),

                                    ),
                                  ),
                                  controller:emailController,


                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    this._data.email = value;
                                  }

                              )),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: TextFormField(
                                  obscureText: true,

                                  decoration: InputDecoration(
                                    icon: Icon(Icons.person),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(color: Colors.blue)),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),

                                    ),
                                  ),

                                  controller:passwordController,

                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    this._data.password = value;
                                  }

                              )

                          ),
                          Container(
                              height: 60,
                              padding: EdgeInsets.only(top:15,left:50,right:50),
                              child: RaisedButton(
                                textColor: Colors.white,
                                color: Colors.blue,
                                child: Text('Login'),
                                onPressed: () async {
                                  //       print(nameController.text);
                                  //     print(passwordController.text);

                                  if (_formKey.currentState.validate()) {

                                    BuildContext dialogContext;
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        dialogContext = context;
                                        return Dialog(
                                          child:Container(
                                            //  padding:EdgeInsets.fromLTRB(10, 10, 10, 0),
                                            width: 20.0,
                                            height:70.0,

                                            child:Row(

                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:<Widget> [
                                                CircularProgressIndicator(),
                                                Padding(
                                                  padding: EdgeInsets.only(left:20),
                                                  child: Text('Please Wait!'),
                                                )
                                              ],
                                            ),                             ),
                                        );
                                      },
                                    );
                                    String res= await addLocal(emailController.text,passwordController.text).
                                    whenComplete(() =>Navigator.pop(dialogContext)
                                    );

                                    await _displayResponse(context, res);
                                    Navigator.push(context,MaterialPageRoute(builder:(context)=>MyApp()));
                                  }},

                              )),
                          Container(
                              padding: EdgeInsets.only(left:10),

                              child: Row(
                                children: <Widget>[
                                  Text('Does not have account?'),
                                  FlatButton(
                                    textColor: Colors.blue,
                                    child: Text(
                                      'Register',
                                      style: TextStyle(fontSize: 20),
                                    ),

                                    onPressed: () {

                                      Navigator.push(context,MaterialPageRoute(builder:(context)=>SecondPage()));

                                    },
                                  )
                                ],
                                // mainAxisAlignment: MainAxisAlignment.center,
                              ))


                        ],


                      ),
                    )
                ))));


  }
}

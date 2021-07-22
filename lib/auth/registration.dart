import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:food/main.dart';

Future<String> makePostRequest(n,m,p) async {

  await new Future.delayed(const Duration(seconds: 5));
  Register register=Register(n,m,p);
  String jsonRegister=jsonEncode(register);
  print(jsonRegister);

// set up POST request arguments
  String url = 'http://hospital.impelcreations.co.in/hosp/Api/flut';
  Map<String, String> headers = {"Content-type": "application/json"};

  // String json = '{"title"t
  try{
    http.Response response = await http.post(url, headers: headers, body: jsonRegister);
    // check the status code for the result
    //final Map responseJson = json.decode(response.body);

    if (response.statusCode == 200) {
      print(response.body.toString());

      var  data=jsonDecode(response.body);
      String status=data["status"];
      //print(data["status"]);
      //print(response.body.toString());
      // await new Future.delayed(const Duration(seconds: 2));
      // return (response.body.toString());
      return status;
    }}
  catch(err){

    print('Caught error: $err');
    return err;
  }

}
//else{
// If that call was not successful, throw an error.
// String status="Something Went wrong....";
//return status;
//}
//}
Future<void>_displayResponse(context,res) async {
  if(res=="success")
  {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('API Response'),
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
        });}
}
class Register{
  final String name;
  final String email;
  final String password;

  Register(this.name,this.email,this.password);

  Map toJson() => {
    'name': name,
    'email': email,
    'password':password

  };


}
void main(){
  runApp(MaterialApp(
    home: SecondPage(),
  ));
}
class SecondPage extends StatefulWidget {
  @override
  _State createState() =>_State();
}

class _State extends State<SecondPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String res='';
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.yellow,
          //   title: Text('Second screen'),
        ),
        body:Padding(
            padding: EdgeInsets.all(1),
            child:new Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: 20),
                        )),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.person,
                            color:Colors.amber,
                          ),
                          labelText: 'User Name',
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),
                          enabledBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.blue)),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),

                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller:nameController,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child:TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.mail,
                              color:Colors.amber
                          ),
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller:emailController,

                      ),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.remove_red_eye,
                              color:Colors.amber
                          ),
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller:passwordController,

                      ),
                    ),
                    Container(

                      height: 50,
                      padding: EdgeInsets.only(top:20,left:20,right:20),

                      child:RaisedButton(
                        textColor: Colors.white,
                        color: Colors.deepOrangeAccent,
                        child: Text('Submit'),

                        onPressed:() async {
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
                            String res= await makePostRequest(nameController.text,emailController.text,passwordController.text).
                            whenComplete(() =>Navigator.pop(dialogContext)
                            );

                            await _displayResponse(context, res);
                            Navigator.push(context,MaterialPageRoute(builder:(context)=>MyApp()));




                            Navigator.push(context,MaterialPageRoute(builder:(context)=>MyApp()));

                          }},
                        //makePostRequest(nameController.text,emailController.text,passwordController.text);


                      ),




                    ),
                  ],
                ))   ) );

  }
}
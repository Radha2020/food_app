//import 'dart:html';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/model/cart.dart';
import 'package:food/model/items.dart';
import 'package:food/model/waiters.dart';

import 'package:food/page/menu.dart';
import 'package:food/services/Services.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:badges/badges.dart';
//import 'package:dropdownfield/dropdownfield.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:food/page/viewcart.dart';
import 'package:food/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food/page/viewcart.dart';
import 'package:food/database_helper.dart';
import 'package:badges/badges.dart';
import 'package:http/http.dart' as http;
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';

class Tno {
  String tno;
  Tno({this.tno});
  @override
  String toString() {
    return '${tno}';
  }
}

void main() {
  runApp(MaterialApp(
    home: KotPage(),
  ));
}

enum Condition { AC, NON_AC }
enum WidgetMarker { first, second, third }

class KotPage extends StatefulWidget {
  @override
  _KotPageState createState() => _KotPageState();
}

class _KotPageState extends State<KotPage> {
  var isLoading = false;
  bool pressed = false;
  bool waiterselected = true;
  String s;
  Future _future;
  final dbHelper = DatabaseHelper.instance;
  String code;
  WidgetMarker selectedWidgetMarker = WidgetMarker.first;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  int _id;
  String totaltables;
  int _delid;
  List<Items> items = List();
  List<Items> filtereditems = List();
  List<Waiters> waiters = [];
  Waiters selectedvalue;
  List<String> dropdownText = [];
  String selectedtableno='';
  String tableno='';

  List<String> result;
  List<Tno> tno;
  List<String> tablenumbers = [];
  Tno selNumber;
  int _counter;
  int tableid;
  int row_count = 0;
  bool selected;
  String data = "";
  var list;
  //waiter no,name
  String selNum = "";
  String selName = "";
  int _n = 1;
  int quan;
  String totPrice = "";
  //radio button next 2 var
  String radioButtonItem = "";
  int id = -1;
  int rowid;
  int _lastrowid;
  String finalDate = '';
  String selectTNO = "";
  String ind = "";
  int qty;
  String searchString = "";
  int _total;
  final TNOselected = TextEditingController();
  TextEditingController kotcontroller = TextEditingController();
  TextEditingController codecontroller = TextEditingController();

  String selectedtno = "";
  String selectedPrice = "";
  String selectedItem = "";
  String selectedCode = '';
  @override
  void initState() {
    super.initState();
    //  loaddropdown();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    getcounter();
    gettabledetails();
    Services.fetchwaiters().then((waitersFromServer) {
      setState(() {
        waiters = waitersFromServer;
       // waiterselected = true;
      });
    });
    Services.fetchData().then((itemsFromServer) {
      setState(() {

//       dbHelper.deleteall();
  //     dbHelper.deletetable();
        items = itemsFromServer;
        filtereditems = items;
       // _counter=0;
      });
    });
//print(waiters);
    // setState(() {
    // selectedWidgetMarker=WidgetMarker.first;
    //  _future=Services.fetchData();
    //_calcTotal();
    //});
    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    finalDate = formattedDate.toString();
    kotcontroller.text = "890";
    tno = [
      Tno(tno: "11"),
      Tno(tno: "12"),
      Tno(tno: "13"),
      Tno(tno: "14"),
      Tno(tno: "15"),
      Tno(tno: "21"),
      Tno(tno: "22"),
    ];
  }

  Future <List<String>>loaddropdown() async {
    print("loaddropdown");
    final allRows =await dbHelper.queryTableDetails();
    print('query KOT details:');
    allRows.forEach((row) => print(row));
    final text=await dbHelper.queryTableNumbers();
    dropdownText.clear();
    text.forEach((row) =>{dropdownText.add(row['tableno'] )});

    // allRows.forEach((row) => tabsText.add(tableno));
    print(dropdownText);
    print(text.length);

    final Rows =await dbHelper.queryTableDetails();
    print('query all rows:');
    Rows.forEach((row) => print(row));

    setState(() {
      selectedWidgetMarker = WidgetMarker.second;
      Services.fetchData().then((itemsFromServer) {
        setState(() {
          items = itemsFromServer;
          filtereditems = items;
          _total = null;
          _counter = 0;
        });
      });
    });

    final lastrowid=await dbHelper.getlastrowid().then((value) => _lastrowid=value);
    final lasttableno=await dbHelper.gettableNoPerId(_lastrowid).then((value) => selectedtableno=value.toString());


    setState(() {
      selectedtableno=selectedtableno;
      dropdownText=dropdownText;
    });
//return dropdownText;

  }
  void gettabledetails() async
  {
   print("table dtls");
    final allRows = await dbHelper.queryTableDetails();
    allRows.forEach((element)=> {selName=element['waitername']??''});
    allRows.forEach((element)=> {selNum=element['waiterno']??''});
print("waitername");
print(selName);
    print('query Table dtls:');
    allRows.forEach((row) => print(row));

   final allRows1=await dbHelper.queryAllRows();
   print('query menu dtls:');
   allRows1.forEach((row) => print(row));


final count=await dbHelper.queryTableNumbers();
   print('query Table numbers:');
   //count.forEach((row) => print(row));
   tablenumbers.clear();
   count.forEach((row) =>{tablenumbers.add(row['tableno'] )});
//   List<String> list = ['one', 'two', 'three'];
   final string = tablenumbers.reduce((value, element) => value + ',' + element);


   setState(() {
     s=string;
   });
   // allRows.forEach((row) => tabsText.add(tableno));
   print(tablenumbers);
   print(count.length);

//SharedPreferences prefs = await SharedPreferences.getInstance();

  // selName=prefs.getString('waitername');
if(selName.isEmpty){
setState(() {
  waiterselected=true;
});
}else{
 print("waitername");
print(selName);
   setState(() {
 // pressed=false;
  waiterselected=false;
  selName=selName;

 });
}

  }
   void getcounter() async {
    final lastrowid =
    await dbHelper.getlastrowid().then((value) => _lastrowid = value);
    var count = await dbHelper
        .queryRowCountperid(_lastrowid)
        .then((value) => _counter = value);
    print(_counter);
    setState(() {
      _counter = _counter;
      print(_counter);
    });
  }

    void tabledetails() async {
      print("number");
      print(kotcontroller.text);
      print("type,date,tno");
      print(radioButtonItem.toString());
      print(finalDate);
      print(selNumber.toString());
      print("waiter no and name");
      print(selName);
      print(selNum.toString());

      Map<String, dynamic> row = {
        DatabaseHelper.columnKot: kotcontroller.text,
        DatabaseHelper.columnType: radioButtonItem.toString(),
        DatabaseHelper.columnDate: finalDate,
        DatabaseHelper.columnWaiterno: selNum.toString(),
        DatabaseHelper.columnWaitername: selName.toString(),
        DatabaseHelper.columnTableno: selNumber.toString(),
      };

      final id = await dbHelper.insert(row);
      print('new row inserted');
      print('inserted row id: $id');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('kot', kotcontroller.text);
      prefs.setString('waiterno', selNum);
      prefs.setString('waitername', selName);

      final allRows = await dbHelper.queryTableDetails();
      print('query all rows:');
      allRows.forEach((row) => print(row));
    }




  Future<int> getquan(code) async {
    print("code:");
    print(code);
    var q = await dbHelper.getquantity(code, id).then((value) => quan = value);
    setState(() {
      quan = quan;
      print("quantity from db");
      print(quan);
    });
    return quan;
  }
  void add(code, _n, price) async {
    var tot = _n * int.parse(price);
    Map<String, dynamic> row = {
      DatabaseHelper.columnCode: code,
      DatabaseHelper.columnQuantity: _n,
      DatabaseHelper.columnTotal: tot,
    };
    dbHelper.update(row,tableid);
    _calcTotal();

    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }
  void update() async {
    //_future=fetchData();

    print("back to menu");
//    var c= await dbHelper.queryRowCount().then((value) =>_counter=value);

    final allRows = await dbHelper.queryAllRows();
    _calcTotal();

    print('query all rows:');
    allRows.forEach((row) => print(row));
    final lastrowid =
    await dbHelper.getlastrowid().then((value) => _lastrowid = value);
    var count = await dbHelper
        .queryRowCountperid(_lastrowid)
        .then((value) => _counter = value);

    setState(() {
      _counter = _counter;

      Services.fetchData().then((itemsFromServer) {
        setState(() {
          items = itemsFromServer;
          filtereditems = items;
        });
      });
//     _future=fetchData();
    });
  }
  void minus(code, _n, price) async {
    print(code);
    var tot = _n * int.parse(price);
    Map<String, dynamic> row = {
      DatabaseHelper.columnCode: code,
      DatabaseHelper.columnQuantity: _n,
      DatabaseHelper.columnTotal: tot,
    };
    dbHelper.update(row,tableid);
    _calcTotal();

    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }
  void del(code) async {
    print("code");
    print(code);
    dbHelper.del(code);
    var count =
    await dbHelper.queryRowCount().then((value) => _counter = value);
    setState(() {
      _counter = _counter;
    });
    _calcTotal();
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }
  void _calcTotal() async {
    var total = await dbHelper
        .calculateTotalperid(rowid)
        .then((value) => _total = value);
    //print(total);
    setState(() => _total = _total);
  }
  submitkitchenData(tableid) async {

    //final id = await dbHelper.getlastrowid().then((value) => rowid = value);
    setState(() {
      rowid = tableid;
      print("rowid");
      print(id);
    });
    print(id);
    //final tableno=await dbHelper.gettableno(id);
    // print(tableno);
    //print("submitted quantiy");
    //  print(_n);

    // print(selectedPrice);
    int price = int.parse(selectedPrice);
    int total = _n * price;
    // print(price);
    Map<String, dynamic> row = {
      DatabaseHelper.columnTableId: rowid,
      DatabaseHelper.columnCode: selectedCode,
      DatabaseHelper.columnDesc: selectedItem,
      DatabaseHelper.columnPrice: price,
      DatabaseHelper.columnQuantity: _n,
      DatabaseHelper.columnTotal: total
    };
    int c = await dbHelper.getcount(selectedCode, rowid);

    //var r= dbHelper.getcount(selectedCode).then((value) => c=value);
    //  print("count");
    print(c);
    //int count=r;
    if (c == 0) {
      Cart cart = Cart.fromMap(row);
      final id = await dbHelper.insertrow(cart);
      print('new row inserted');
      //final id = await dbHelper.insert(row);
      print('inserted row id: $id');
    } else {
      print(row);
      print("already existed");
      dbHelper.update(row,tableid);
    }

    var count = await dbHelper
        .queryRowCountperid(rowid)
        .then((value) => _counter = value);
    _calcTotal();
    setState(() {
      _counter = _counter;
    });
    //dbHelper.delete();
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }
backfrommenu() async{
print("back from menu");
}
  loadData(selectedtableno) async {
    // print(kotcontroller.text);
    // print(radioButtonItem);
    // print(finalDate);
//    _future = Services.fetchData();
    print(selectedtableno);
    if (_counter != 0)
      var res = Navigator.push(
          context, MaterialPageRoute(builder: (context) => ViewCart(tableno:selectedtableno.toString())))
          .whenComplete(() => update());
  }

  void _validateInputs() async {
    final form = _formKey.currentState;
    print("form validation");
   // print(waiterselected);
   // print(id);
    print("tableno");
    print(selNumber);
    print(selNum);

print("check table no");
  int num=await dbHelper.gettablecount(selNumber);
  print(num);
  setState(() {
    totaltables=num.toString();
  });
    if (id == -1) {
      print(id);
      final snackBar = SnackBar(
          backgroundColor: Colors.red, content: Text("select AC or NON_AC"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else if (selName==null) {
      final snackBar = SnackBar(
          backgroundColor: Colors.red, content: Text('Select waiter name'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else if (selNumber == null) {
      final snackBar = SnackBar(
          backgroundColor: Colors.red, content: Text('Select table number'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    else if (num>0) {
      final snackBar = SnackBar(
          backgroundColor: Colors.red, content: Text('Table number already exist'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    if (id != -1 && selName!=null && selNumber != null && num==0) {
      print("insert table details");
      tabledetails();
      setState(() {
        pressed = true;
        waiterselected = false;
      });
    }
  }

  void dialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text('Pls fill the table details'),
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
  displaydetails(tableno)async{
    print("tableno");
    print(tableno);
    var id=await dbHelper.gettableIdPerNo(tableno).then((value) => tableid=value);
    print("tableid");
    print(tableid);
    var total =await dbHelper.calculateTotalperid(tableid).then((value) => _total=value);
    print(total);

    var count=await dbHelper.queryRowCountperid(tableid).then((value) => _counter=value);
    Services.fetchData().then((itemsFromServer) {
      setState(() {
        items = itemsFromServer;
        filtereditems = items;
      });
    });

    setState(() {
      _total = _total;
      _counter=_counter;
    });
  }

  Widget details() {
    //print("widget 2");



    return Column(
        children: <Widget>[

          Row(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new DropdownButton(
                    hint:Text(
                      'Select Table',
                      style: TextStyle(color: Colors.black),
                    ),
                    value: selectedtableno.isNotEmpty ? selectedtableno : null, //
                   // value:selectedtableno,
                    // underline: SizedBox(),
                    items:dropdownText.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged:(value){
                      print(value);

                      setState(() {
                        selectedtableno=value.toString();

                      });
//    String number=value.toString();
                //      displaydetails(selectedtableno);

                    }
                ),

                SizedBox(width: 20.0),
                Text('TableNo:.$selectedtableno',style:TextStyle(fontWeight:FontWeight.bold,fontSize:15),)

              ]

          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (string) {
                setState(() {
                  filtereditems = items
                      .where((i) =>
                  i.code.toLowerCase().contains(string.toLowerCase()) ||
                      i.desc.toLowerCase().contains(string.toLowerCase()))
                      .toList();
                });
              },
              //  controller: editingController,
              controller: codecontroller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Enter code or desc',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          new Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: filtereditems.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: new ListTile(
                            title: Text('${filtereditems[index].desc}'),
                            subtitle: Row(
                              children: <Widget>[
                                Text('Rs:'),
                                Text('${filtereditems[index].price}'),
                              ],
                            ),
                            leading: Text('${filtereditems[index].code}'),
                            trailing:
                            // code=snapshot.data[index].code

                            filtereditems[index].ShouldVisible
                                ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RaisedButton(
                                    color: Colors.green,
                                    onPressed: () async {
                                      print("tableno");
                                      print(selectedtableno);
                                      print("code value");
                                      print(items[index].code);
                                      final id = await dbHelper.gettableIdPerNo(selectedtableno).then((value) => tableid = value);
//                                            final id = await dbHelper.getlastrowid().then((value) => tableid = value);
                                      print("tableid");
                                      print(tableid);
                                      var t = await dbHelper
                                          .getquantity(
                                          items[index].code, tableid)
                                          .then((value) => quan = value);
                                      print("quan");
                                      print(quan);

                                      if (quan == null) {
                                        print("if part");
                                        _n = 1;
                                        totPrice =
                                            filtereditems[index].price;
                                        filtereditems[index].isAdded =
                                        false;
                                      } else {
                                        final snackBar = SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                            'Already Added in the Cart!!',
                                          ),
                                          duration: Duration(seconds: 2),
                                        );
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                        //               _showScaffold("This is a SnackBar.");
                                        print("else part");
                                        _n = quan;
                                      }
                                      setState(() {
                                        filtereditems[index]
                                            .ShouldVisible = false;
                                        selectedItem =
                                            filtereditems[index].desc;
                                        selectedPrice =
                                            filtereditems[index].price;
                                        selectedCode =
                                            filtereditems[index].code;
                                        filtereditems[index].counter = _n;
                                      });
                                      submitkitchenData(tableid);
                                    },
                                    child: new Text('ADD',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    textColor: Colors.white,
                                  )
                                ])
                            //
                                : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: new Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (filtereditems[index].counter >1) {
                                          filtereditems[index].counter--;
                                          _n = filtereditems[index]
                                              .counter;
                                          minus(
                                            filtereditems[index].code,
                                            _n,
                                            filtereditems[index].price,
                                          );
                                        } else {
                                          print(filtereditems[index]
                                              .counter);
                                          setState(() {
                                            filtereditems[index]
                                                .ShouldVisible = true;
                                            filtereditems[index].isAdded =
                                            true;
                                          });
                                          del(filtereditems[index].code);
                                        }
                                      });
                                    },
                                    color: Colors.green,
                                  ),
                                  Text(filtereditems[index]
                                      .counter
                                      .toString()),
                                  IconButton(
                                    icon: new Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _id = index;
                                        filtereditems[index].counter++;
                                        _n = filtereditems[index].counter;
                                        add(
                                          filtereditems[index].code,
                                          _n,
                                          filtereditems[index].price,
                                        );
                                      });
                                    },
                                    color: Colors.green,
                                  )
                                ])),
                      ));
                }),
          ),
        ]);
  }

  Widget first() {
    return Container(
      child: SingleChildScrollView(
        child: new Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Container(
                  padding:
                  EdgeInsets.only(top: 34, left: 14, right: 14, bottom: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: 50,
                        padding: EdgeInsets.only(left: 20),
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            // labelText: 'KOT',
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
                              return 'Please enter value';
                            }
                            return null;
                          },
                          controller: kotcontroller,
                        ),
                      ),
                      SizedBox(width: 60),
                      Radio(
                        value: 1,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'AC';
                            id = 1;
                          });
                        },
                      ),
                      Text(
                        'AC',
                        style: new TextStyle(fontSize: 17.0),
                      ),
                      Radio(
                        value: 2,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'NON-AC';
                            id = 2;
                          });
                        },
                      ),
                      Text(
                        'NON-AC',
                        style: new TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  )),
              Divider(
                color: Theme.of(context).primaryColor,
                thickness: 1,
              ),
              Row(
                children: <Widget>[
                  waiterselected
                      ? Container(
                      padding: EdgeInsets.only(left: 20),
                      child: SearchableDropdown(
                        hint: Text('Waiter Name'),
                        items: waiters.map((item) {
                          return new DropdownMenuItem<Waiters>(
                            value: item,
                            child: Text(item.waitername),
                          );
                        }).toList(),
                        value: selectedvalue,
                        isCaseSensitiveSearch: true,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.red),
                        searchHint: new Text(
                          'Select ',
                          style: new TextStyle(fontSize: 20),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedvalue = value;
                            selName = value.waitername;
                            selNum = value.id;
                            print(selName);
                            print(selNum);
                          });
                        },
                      ))
                      : Container(
                      child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () {},
                          padding: const EdgeInsets.all(8.0),
                          child: new Text(
                            "$selName",
                          )))
                ],
              ),

              Divider(
                color: Theme.of(context).primaryColor,
                thickness: 1,
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(left: 50),
                        child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blue,
                            onPressed: () {},
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              "Clerk",
                            ))),
                    SizedBox(width: 40),
                    Container(
                        child: SearchableDropdown(
                          hint: Text('Table No'),

                          items: tno.map((item) {
                            return new DropdownMenuItem<Tno>(
                              value: item,
                              child: Text(item.tno),
                            );
                          }).toList(),
                          value: selNumber,
                          isCaseSensitiveSearch: true,

                          icon:
                          const Icon(Icons.arrow_drop_down, color: Colors.red),

                          searchHint: new Text(
                            'Select ',
                            style: new TextStyle(fontSize: 20),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selNumber = value;
                              print(selNumber);
                            });
                          },
                          //  validator: (value) {
                          //  if (selNumber == null) {
                          // return 'Table No is required';
                          // }
                          // },
                        )),
                    SizedBox(width: 15),
                  ]),

              Divider(
                color: Theme.of(context).primaryColor,
                thickness: 1,
              ),
              SizedBox(height: 15),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FloatingActionButton.extended(
                        heroTag: null,
                        label: new Text("submit"),
                        onPressed: () {
                          _validateInputs();
                        }),
                    FloatingActionButton.extended(
                        heroTag: null,
                        backgroundColor: Colors.redAccent,
                        label: new Text("Add Table"),
                        onPressed: () async {
                          print("Add Table");
                          setState(() {
                            //  dbHelper.deleteall().then((value) => print(value));
                            //getcounter();
                            pressed = false;
                            selNumber = null;
                            id = -1;
                            _total = null;
                            _counter = 0;
                            dialog();
                          });
                        }),
                  ]),
              SizedBox(height: 15),

              FloatingActionButton.extended(
                  backgroundColor: Colors.green,
                  heroTag: null,
                  label: new Text("AddMenu"),
                  onPressed: () async {
                    //   loaddropdown();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MenuPage())).whenComplete(() =>backfrommenu());


                  }),

  /*            pressed

                  ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FloatingActionButton.extended(
                        backgroundColor: Colors.green,
                        heroTag: null,
                        label: new Text("AddMenu"),
                        onPressed: () async {
                      //   loaddropdown();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MenuPage())).whenComplete(() =>backfrommenu());


                        }),
                  ])
                  : Container()
*/
              //)
            ])),
      ),
    );
  }

  Widget getCustomContainer() {
    switch (selectedWidgetMarker) {
      case WidgetMarker.first:
        return first();
      case WidgetMarker.second:
        return details();
    }

    return first();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Colors.lightGreen,

      appBar: new  AppBar(
        title: new Text(
          "Table Details",
          style: new TextStyle(color: Colors.white),
        ),
      ),
      bottomNavigationBar:
BottomAppBar(
      child: Container(
      height: 50,
      child: Row(
         // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
      FlatButton(
      padding: EdgeInsets.all(2.0),
      onPressed: () {
        setState(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyApp()));
        });


      },
      child: Column(
        children: <Widget>[
          Icon(Icons.home),
          Text('Home')
        ],
      ),
    ),
            Container(color: Colors.black, width: 2,),
            FlatButton(
              padding: EdgeInsets.all(2.0),
              onPressed: () {},
              child: Column(
                children: <Widget>[
                  s==null
                  /*    ? Badge(
                shape: BadgeShape.square,
                borderRadius: BorderRadius.circular(5),
                badgeColor: Colors.red,
                position: BadgePosition.topEnd(top: -12, end: -20),
                padding: EdgeInsets.all(2),
                badgeContent: Text(
                  'Rs.' '$_total',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
                child: Text(
                  'Pending Tables',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )*/
                      ?Text('Pending Tables',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )
                      : Text('Pending Tables:$s',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),   ],
              ),
            ),


      /*new BottomNavigationBar(
        // currentIndex: 0, // this will be set when a new tab is tapped
          backgroundColor: Colors.white,
          selectedFontSize: 1.0,
          unselectedFontSize: 1.0,

          items: [

            BottomNavigationBarItem(
              icon: new Stack(children: <Widget>[
                IconButton(
                  icon: new Icon(Icons.home),
                  color: Colors.brown,
                  onPressed: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    });
                  },
                  //loadData();
                ),
              ]),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              title: Text(''),
              icon: s==null
              /*    ? Badge(
                shape: BadgeShape.square,
                borderRadius: BorderRadius.circular(5),
                badgeColor: Colors.red,
                position: BadgePosition.topEnd(top: -12, end: -20),
                padding: EdgeInsets.all(2),
                badgeContent: Text(
                  'Rs.' '$_total',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
                child: Text(
                  'Pending Tables',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )*/
                 ?Text('pending Tables',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              )
                  : Text('Pending Tables:$s',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          /*  BottomNavigationBarItem(
              icon: new Stack(
                children: <Widget>[
                  IconButton(
                    icon: new Icon(Icons.shopping_cart),
                    color: Colors.brown,
                    onPressed: () {
                      loadData(selectedtableno);

                      // setState(() {
                      //selectedWidgetMarker=WidgetMarker.third;
                      //});
                    },
                  ),
                  // new Icon(Icons.shopping_cart,size:35,color: Colors.brown,),
                  _counter != 0 && _counter != null
                      ? new Positioned(
                    right: 0,
                    child: new Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: new Text(
                        '$_counter',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                      : new Positioned(
                    right: 0,
                    child: new Container(),
                  )
                ],
              ),
              title: Text(''),
            ),*/

          ]),*/
])
    )
    ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: getCustomContainer(),
          )
        ],
      ),
    );
  }
}

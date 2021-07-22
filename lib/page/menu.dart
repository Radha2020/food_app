//import 'dart:html';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/model/cart.dart';
import 'package:food/model/items.dart';
import 'package:food/model/waiters.dart';
import 'package:food/page/kot.dart';
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
void main() {
  runApp(MaterialApp(
    home: MenuPage(),
  ));
}

class MenuPage extends StatefulWidget {
  final String tableno;
  MenuPage({Key key, @required this.tableno}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final dbHelper = DatabaseHelper.instance;
  int _id;
  int _delid;
  List<Items> items = List();
  List<Items> filtereditems = List();
  List<String> dropdownText = [];
  String selectedtableno='';
  String tableno='';
  List<String> result;
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
     loaddropdown();
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
   // getcounter();
    Services.fetchData().then((itemsFromServer) {
      setState(() {
        items = itemsFromServer;
        filtereditems = items;
        _counter=0;
      });
    });
  //  SnackBar(
    //    backgroundColor: Colors.red, content: Text("pls select the table number"));
    //_scaffoldKey.currentState.showSnackBar(snackBar);
 // }
}
  Future <List<String>>loaddropdown() async {
    print("loaddropdown");
    final allRows =await dbHelper.queryTableDetails();
    print('query KOT details:');
    allRows.forEach((row) => print(row));
    final text=await dbHelper.queryTableNumbers();
    dropdownText.clear();
    text.forEach((row) =>{dropdownText.add(row['tableno'] )});
setState(() {
  dropdownText=dropdownText;
});
    // allRows.forEach((row) => tabsText.add(tableno));
    print(dropdownText);
    print(text.length);

  //  final Rows =await dbHelper.queryTableDetails();
  //  print('query all rows:');
  //  Rows.forEach((row) => print(row));

    setState(() {
  //    selectedWidgetMarker = WidgetMarker.second;
      Services.fetchData().then((itemsFromServer) {
        setState(() {
          items = itemsFromServer;
          filtereditems = items;
          //_total = null;
         // _counter = 0;
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
 void getcounter(rowid) async {
    print("rowid");
    print(rowid);
   // final lastrowid =await dbHelper.getlastrowid().then((value) => _lastrowid = value);
    var count = await dbHelper
        .queryRowCountperid(rowid)
        .then((value) => _counter = value);
    print(_counter);
    setState(() {
      _counter = _counter;
      print(_counter);
    });
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
    print("back to menu");
  print(selectedtableno);
    var id=await dbHelper.gettableIdPerNo(selectedtableno).then((value) => tableid=value);
    var total =await dbHelper.calculateTotalperid(tableid).then((value) => _total=value);
    var count = await dbHelper.queryRowCountperid(tableid).then((value) => _counter = value);

    setState(() {
      _total=_total;
     _counter=_counter;
    });
    setState(() {
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
    print("minus part");
    print(code);
    var tot = _n * int.parse(price);
    Map<String, dynamic> row = {
      DatabaseHelper.columnCode: code,
      DatabaseHelper.columnQuantity: _n,
      DatabaseHelper.columnTotal: tot,
    };
    dbHelper.update(row,tableid);
    _calcTotal();
    print("tableid");
    print(tableid);
   getcounter(tableid);
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }
  void del(tableid,code) async {
    print("code");
    print(code);
    print(tableid);
   // dbHelper.del(code);
   dbHelper.deleterow(tableid,code);
    var count =
    await dbHelper.queryRowCountperid(tableid).then((value) => _counter = value);
    setState(() {
      _counter = _counter;
    });
    _calcTotal();
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }
  void _calcTotal() async {
print("calculate total");
print("rowid");

print(rowid);
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
    print(id);   int price = int.parse(selectedPrice);
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

  loadData(selectedtableno) async {
    print(selectedtableno);
    if (_counter != 0)
      var res = Navigator.push(
          context, MaterialPageRoute(builder: (context) => ViewCart(tableno:selectedtableno.toString())))
          .whenComplete(() => update());
  }

 displaydetails(tableno)async{
    print("tableno");
    print(tableno);
    var id=await dbHelper.gettableIdPerNo(tableno).then((value) => tableid=value);
    setState(() {
      tableid=tableid;
    });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
             appBar: AppBar(
        title: new Text(
          "Menu",
          style: new TextStyle(color: Colors.white),
        ),
       // leading: new IconButton(
       //   icon: new Icon(Icons.arrow_back),
       //   onPressed: () {
        //    Navigator.push(context,
        //        MaterialPageRoute(builder: (context) => KotPage()));
      //       submit(selectedtableno);         },
         //  },
      //  ),
      ),

      bottomNavigationBar: new BottomNavigationBar(
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
              icon: _total != null
                  ? Badge(
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
                  'Total',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )
                  : Text(
                'Total',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            BottomNavigationBarItem(
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
            ),
          ]),

      body: Column(
        children: <Widget>[

          Row(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new DropdownButton(
                    hint:Text(
                      'Select Table',
                      style: TextStyle(color: Colors.black),
                    ),  value: selectedtableno.isNotEmpty ? selectedtableno : null, //                    // underline: SizedBox(),
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
                      displaydetails(selectedtableno);

                    }
                ),

                SizedBox(width: 20.0),
                Text('TableNo:.$selectedtableno',style:TextStyle(fontWeight:FontWeight.bold,fontSize:15),)

              ]

          ),
Row(
    children: <Widget>[  FloatingActionButton.extended(
        backgroundColor: Colors.green,
        heroTag: null,
        label: new Text("AddTable"),
        onPressed: () async {
          //   loaddropdown();
         // Navigator.push(context,
         //     MaterialPageRoute(builder: (context) => KotPage()));

          Navigator.pushAndRemoveUntil( context, MaterialPageRoute(builder: (context) => KotPage()), (Route<dynamic> route) => false, );;

        }),
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
                             // ),
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
                                         print("id");
                                         print(tableid);

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
                                          del(tableid,filtereditems[index].code);
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
                                        add(filtereditems[index].code,_n,filtereditems[index].price,
                                        );
                                      });
                                    },
                                    color: Colors.green,
                                  )
                                ])),
                      ));
                }),
          ),
        ],
      ),
    );
  }
}

//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';
import 'dart:async';
import 'package:food/database_helper.dart';
import 'package:food/model/cart.dart';
import 'package:food/model/details.dart';
import 'package:food/page/kot.dart';
import 'package:food/page/menu.dart';
import 'package:food/services/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CheckOut(),
    );
  }
}

class CheckOut extends StatefulWidget {
  final String tableno;
  CheckOut({Key key, @required this.tableno}) : super(key: key);

  @override
  CheckOutState createState() => CheckOutState();
}

class CheckOutState extends State<CheckOut> {
  final dbHelper = DatabaseHelper.instance;
  List<Details> dtls = [];
  List<Cart> cart = [];

  List<String> dropdownText = [];
  String kot = '';
  String waitername = '';
  String tableno = '';
  String selectedtableno = '';
  int tableid;
  int _lastrowid;
  int totalitems;
  int _total;
  final ScrollController _controllerOne = ScrollController();
  @override
  void initState() {
    super.initState();
    print("checkout  screen");
    _loaddata();
    //_calcTotal();
  }

  void _calcTotal() async {
    var total = await dbHelper.calculateTotal().then((value) => _total = value);
    print(total);
    setState(() => _total = _total);
  }

  afterstored() async {
    print("After Stored");
    final lastrowid =
        await dbHelper.getlastrowid().then((value) => _lastrowid = value);
    final lasttableno = await dbHelper
        .gettableNoPerId(_lastrowid)
        .then((value) => selectedtableno = value.toString());

    setState(() {
      _lastrowid = _lastrowid;
      tableno = selectedtableno;
    });
    final Rows = await dbHelper.queryCheckOutDetailsPerId(_lastrowid);
    print(' if query item details :');
    Rows.forEach((row) => print(row));
    cart.clear();
    Rows.forEach((row) => cart.add(Cart.fromMap(row)));
    totalitems = cart.length;
    setState(() {
      cart = cart;
      tableno = tableno;
    });
  }

  Future<List<Details>> _loaddata() async {
    print("check out page");
    final allRows = await dbHelper.queryTableDetails();
    print('query KOT details:');
    allRows.forEach((row) => print(row));
    print("table dtls");
    print(allRows.length);
    if (allRows.length == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        kot = prefs.getString('kot');
        waitername = prefs.getString('waitername');
      });
    } else {
      allRows.forEach((element) => {kot = element['kot'] ?? ''});
      allRows.forEach((element) => {waitername = element['waitername'] ?? ''});
      print(allRows);
    }

    final text = await dbHelper.queryTableNumbers();
    text.forEach((row) => {dropdownText.add(row['tableno'])});

    // allRows.forEach((row) => tabsText.add(tableno));
    print(dropdownText);
    print(text.length);
    setState(() {
      dropdownText = dropdownText;
    });
    // var tablecount=await dbHelper.queryTableCount().then((value) => _tablecount=value);
    //print(tablecount);
    dtls.clear();
    allRows.forEach((row) => dtls.add(Details.fromMap(row)));
    //final lasttableno=await dbHelper.gettableNoPerId(_lastrowid).then((value) => selectedtableno=value.toString());
    setState(() {
      selectedtableno = widget.tableno;
    });

    print("tableno");
    print(widget.tableno);
    if (widget.tableno == 0) {
      final lastrowid =
          await dbHelper.getlastrowid().then((value) => _lastrowid = value);
      final lasttableno = await dbHelper
          .gettableNoPerId(_lastrowid)
          .then((value) => selectedtableno = value.toString());

      setState(() {
        _lastrowid = _lastrowid;
        tableno = selectedtableno;
      });
      final Rows = await dbHelper.queryCheckOutDetailsPerId(_lastrowid);
      print(' if query item details :');
      Rows.forEach((row) => print(row));
      cart.clear();
      Rows.forEach((row) => cart.add(Cart.fromMap(row)));
      totalitems = cart.length;
    } else {
      final Rows = await dbHelper.queryDetails(widget.tableno);
      print('else query item details :');
      Rows.forEach((row) => print(row));
      cart.clear();
      Rows.forEach((row) => cart.add(Cart.fromMap(row)));
      totalitems = cart.length;

      print(cart.length);
      print(cart);
    }
    setState(() {
      cart = cart;
      tableno = widget.tableno;
    });

    // var total =await dbHelper.calculateTotalperid(_lastrowid).then((value) => _total=value);
    var rowid = await dbHelper
        .gettableIdPerNo(widget.tableno)
        .then((value) => tableid = value);
    var total = await dbHelper
        .calculateTotalperid(tableid)
        .then((value) => _total = value);
    print(total);
    setState(() => _total = _total);

    // var tno =await dbHelper.gettableNoPerId(_lastrowid).then((value) => tableno=value.toString());

    setState(() {
      _total = _total;
      // tableno=selectedtableno.toString();
    });

    print(dtls.length);
    return dtls;
  }

  Future<void> _displayResponse(context, res) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Order Placed Successfully'),
            content: Text('$res'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  setState(() {
                    dbHelper.deleteItemsPerTableNo(tableno);
                    //                afterstored();
                    //tableno="";
                    //  dbHelper.gettableIdPerNo(tableno).then((value) =>tableid=value);
                    dbHelper.delete(tableid);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  submit(tableno) async {
    print(tableno);

    BuildContext dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          child: Container(
            //  padding:EdgeInsets.fromLTRB(10, 10, 10, 0),
            width: 20.0,
            height: 70.0,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Please Wait!'),
                )
              ],
            ),
          ),
        );
      },
    );
    String res = await Services.addRemote(tableno)
        .whenComplete(() => Navigator.pop(dialogContext));

    await _displayResponse(context, res);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MenuPage()),
      (Route<dynamic> route) => false,
    );
    ;
  }

  displaydetails(number) async {
    print("tableno");
    print(number);
    final id =
        await dbHelper.gettableIdPerNo(number).then((value) => tableid = value);
    final Rows = await dbHelper.queryDetails(number);
    // Rows.forEach((element)=> {tableid=element['tableid']??''});

    print('query item details :');
    Rows.forEach((row) => print(row));
    cart.clear();
    Rows.forEach((row) => cart.add(Cart.fromMap(row)));
    totalitems = cart.length;
    print(cart.length);
    print(cart);
    print(tableid);
    var total = await dbHelper
        .calculateTotalperid(tableid)
        .then((value) => _total = value);
    print(total);

    setState(() => _total = _total);
    setState(() {
      cart = cart;
      tableno = number.toString();
    });
  }

  Future<bool> _onWillPop() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/KotPage', (Route<dynamic> route) => false);
  }

  /*List<Tab> tabMaker(){  //return type is specified

    List<Tab> tabs = []; //create an empty list of Tab
    for (var i = 0; i < tabsText.length; i++) {
      tabs.add(Tab(text: tabsText[i])); //add your tabs to the list
    }
    return tabs; //return the list
  }*/
  @override
  Widget build(BuildContext context) {
    //return WillPopScope(
    // onWillPop: _onWillPop,
    //return new Future(() => false);

    return Scaffold(
        // backgroundColor: Colors.lightGreen,
        appBar: AppBar(
          //     backgroundColor: Colors.yellowAccent,
          automaticallyImplyLeading: false,
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Kot:.$kot",
                style: TextStyle(fontSize: 20),
                children: <TextSpan>[
                  TextSpan(
                    text: '\nName:.$waitername',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ]),
          ),
        ),
        body: Column(
          children: <Widget>[
            new DropdownButton(
                hint: Text(
                  'Select Table',
                  style: TextStyle(color: Colors.black),
                ),
                value: selectedtableno,
                // underline: SizedBox(),
                items: dropdownText.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  print(value);
                  selectedtableno = value.toString();
                  String number = value.toString();
                  displaydetails(number);
                }),

            //        Expanded(
            SizedBox(height: 20.0),
            //      Text('Select Table Number', textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
            tableno != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              'TableNo:.$tableno',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )),
                        SizedBox(width: 40.0),
                        Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              'Total Items:.$totalitems',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ))
                      ])
                : Row(),

            Container(
                height: 270,
                child: Scrollbar(
                  controller: _controllerOne,
                  isAlwaysShown: true,
                  child:
                      ListView(controller: _controllerOne, children: <Widget>[
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _controllerOne,
                        child: DataTable(
                          dataRowHeight: 25.0,
                          columnSpacing: 30.0,
                          sortColumnIndex: 1,
                          columns: [
                            // DataColumn(
                            //  label: Text("S.No",   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)  ),
                            //  ),

                            DataColumn(
                              label: Text("Item",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text("Price",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),

                            DataColumn(
                              label: Text("Quantity",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text("Total",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                          rows:
                              cart // Loops through dataColumnText, each iteration assigning the value to element
                                  .map(
                                    ((element) => DataRow(
                                          cells: <DataCell>[
                                            // for(i=1;i<cart.length;i++){
                                            //  DataCell(Text(cart.indexOf(element,0).toString())),
                                            //}
                                            DataCell(Text(element.desc)),
                                            DataCell(
                                                Text(element.price.toString())),
                                            DataCell(Text(
                                                element.quantity.toString())),
                                            DataCell(
                                                Text(element.total.toString())),
                                          ],
                                        )),
                                  )
                                  .toList(),
                        )),
                    _total != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 20, left: 20, right: 20),
                                    child: Text(
                                      'Grand Total:.$_total',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ))
                              ])
                        : Row(),
                  ]),
                )),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FloatingActionButton.extended(
                    heroTag: null,
                    label: new Text("Place Order"),
                    onPressed: () async {
                      if (selectedtableno != null) submit(selectedtableno);
                    },
                  ),

                  /*   FloatingActionButton.extended(
                      heroTag: null,
                      label: new Text("Menu"),
                      onPressed:()  async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MenuPage()));
                        // submit(selectedtableno);         },
                      }
                    ),*/
                ])
          ],
        ));
  }
}

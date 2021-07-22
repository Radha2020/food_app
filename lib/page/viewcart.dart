//import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/main.dart';
import 'dart:async';
import 'package:food/database_helper.dart';
import 'package:food/model/cart.dart';
import 'package:food/page/checkout.dart';
import 'package:food/page/menu.dart';
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
      home: ViewCart(),
    );
  }
}
class ViewCart extends StatefulWidget {
  final String tableno;
  ViewCart({Key key, @required this.tableno}) : super(key: key);
  @override
  ViewCartState createState() => ViewCartState();
}

class ViewCartState extends State<ViewCart> {
  final dbHelper = DatabaseHelper.instance;
  List<Cart> cart=[];
  int _total;
  int qty;
  String code;
  String itemcode;
  String tableno="";
  int price;
  int tot;
  int id;
  int count;
  String desc;
  int _lastrowid;
  int tableid;
  @override
  void initState() {
    super.initState();
    print("second screen");
    print(widget.tableno);
    setState(() {
      tableno=widget.tableno;
    });
    _loaddata();
    _calcTotal(tableno);
  }
  Future <List<Cart>> _loaddata() async {
    final Rows=await dbHelper.queryDetails(tableno);
    print('query item details :');
    Rows.forEach((row) => print(row));
    cart.clear();
    //  print(Rows);
    Rows.forEach((row) => cart.add(Cart.fromMap(row)));
    print(cart.length);
    return cart;
  }
  menuscreen() async{
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MenuPage(tableno:tableno)));
//    Navigator.pop(context);
  }

  add(tableid,code,qty,price) async {
    print("tableid");
    print(tableid);
    print("code");
    print(code);
    var quantity=qty+1;
    var total=quantity*price;
    print(total);
    Map<String, dynamic> row = {
      DatabaseHelper.columnCode :code,
      DatabaseHelper.columnQuantity:quantity,
      DatabaseHelper.columnTotal:total,
    };
    dbHelper.update(row,tableid);
    setState(() {
      _loaddata();
      _calcTotal(tableno);

    });
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));

  }
  minus(tableid,code,qty,price) async {
    print("tableid code,qty,price");
    print(tableid);
    print(code);
    print(qty);
    print(price);
    var quantity=qty-1;
    var total=quantity*price;
    print(total);
    Map<String, dynamic> row = {
      DatabaseHelper.columnCode :code,
      DatabaseHelper.columnQuantity:quantity,
      DatabaseHelper.columnTotal:total,
    };
    dbHelper.update(row,tableid);
    setState(() {
      _loaddata();
      _calcTotal(tableno);
    });
  }

  void _calcTotal(tableno) async{
   //get tableid per tableno
    var id=await dbHelper.gettableIdPerNo(tableno).then((value) => tableid=value);
   var total =await dbHelper.calculateTotalperid(tableid).then((value) => _total=value);
setState(() {
  _total=_total;
});
print(total);   setState(() {
      _total=_total;
    });
  }

  del(id) async {
    print("id:");
    print(id);
    var res=await dbHelper.delete(id).then((value) =>count=value);
    setState(() {
      _loaddata();
      _calcTotal(tableno);
    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // backgroundColor: Colors.lightGreen,
        appBar: AppBar(
          title:Text('Order Details For Table:$tableno',
          ),
        ),
        // automaticallyImplyLeading: false,
        //  ),
        bottomNavigationBar:new BottomNavigationBar(
          // currentIndex: 0, // this will be set when a new tab is tapped
            backgroundColor:Colors.white,
            selectedFontSize: 1.0,
            unselectedFontSize:1.0,
            type: BottomNavigationBarType.fixed,

            items: [
              BottomNavigationBarItem(

                icon:

                new Stack(
                    children: <Widget>[
                      IconButton(
                        icon: new Icon(Icons.home),

                        color: Colors.black,
                        onPressed: (){

                          setState(() {
                            Navigator.push(context,MaterialPageRoute(builder:(context)=>MyApp()));
                          });},
                        //loadData();

                      ),
                    ]
                ),
                title:Text('Home'),

              ),
              BottomNavigationBarItem(

                icon:

                new Stack(
                    children: <Widget>[
                      IconButton(
                        icon: new Icon(Icons.menu),
                        color: Colors.black,
                        onPressed: (){
                          menuscreen();
                        },
                        //loadData();

                      ),
                    ]
                ),
                title:Text(''),

              ),




              BottomNavigationBarItem(

                icon: new Stack(
                  children: <Widget>[
                    IconButton(

                      icon: new Icon(Icons.add_circle,size:40),
                      color: Colors.black,
                      onPressed: (){
                        //loadData();
                        // setState(() {
                        //selectedWidgetMarker=WidgetMarker.third;
                        //});
                      },
                    ),
                    // new Icon(Icons.shopping_cart,size:35,color: Colors.brown,),
                    _total !=null?
                    new Positioned(
                      right: 0,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 15,
                          minHeight: 15,
                        ),
                        child: new Text('Rs.''$_total',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,

                        ),
                      ),
                    )
                        :  new Positioned(
                      right: 0,
                      child: new Container(
                      ),
                    ),

                  ],
                ),
                title: Text(''),
              ),
            ]),
        body:
        Column(
            children:<Widget>[
              Expanded(
                  child:Container(

                      padding: EdgeInsets.all(10),

                      child:FutureBuilder(
                        future: _loaddata(),
                        builder: (context,AsyncSnapshot <List<Cart>> snapshot){
                          print(snapshot.connectionState);
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Container(
                                child: ListView.builder(
                                    itemCount:  snapshot.data.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Card(

                                          child:Padding(
                                              padding:const EdgeInsets.all(10.0),

                                              child:ListTile(
                                                //   title:Text("welcome"),
                                                  title: Text('${snapshot.data[index].desc}'),
                                                  subtitle:Row(

                                                    children: <Widget>[
                                                      //Text('${snapshot.data[index].code}'),
                                                      Text('Rs:'),
                                                      Text('${snapshot.data[index].price}'),
                                                    ],
                                                  ),

                                                  trailing:
                                                  Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children:<Widget>[
                                                        IconButton(
                                                          icon: new Icon(Icons.remove),
                                                          onPressed:(){
                                                            setState(() {

                                                              if(snapshot.data[index].quantity>1)
                                                              {

                                                                tableid=snapshot.data[index].tableid;

                                                                qty=snapshot.data[index].quantity;
                                                                itemcode=snapshot.data[index].code.toString();
                                                                price=snapshot.data[index].price;

                                                                minus(tableid,itemcode,qty,price);
                                                              }
                                                              else{
                                                                id=snapshot.data[index].id;
                                                                del(id);

                                                              }
                                                            });
                                                          },
                                                          color: Colors.green,
                                                        ),

                                                        Text('${snapshot.data[index].quantity}'),
                                                        IconButton(
                                                          icon: new Icon(Icons.add),
                                                          onPressed:(){
                                                            tableid=snapshot.data[index].tableid;
                                                            qty=snapshot.data[index].quantity;
                                                            code=snapshot.data[index].code;
                                                            price=snapshot.data[index].price;
                                                            print(qty);
                                                            add(tableid,code,qty,price);
                                                          },
                                                          color: Colors.green,
                                                        ),

                                                        Text('${snapshot.data[index].total}'),
                                                        IconButton(
                                                          icon: new Icon(Icons.delete),
                                                          color: Colors.redAccent,
                                                          onPressed:(){
                                                            id=snapshot.data[index].id;
                                                            del(id);
                                                          } ,
                                                          padding: const EdgeInsets.all(8.0),
                                                        )])

                                              )));
                                    }));
                          }},
                      ))),
              RaisedButton(
                  child: new Text("Checkout"),
                  onPressed:() async{

                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut(tableno:tableno)));


                  }

              )
            ]));
  }}
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:food/model/cart.dart';
import 'dart:async';
class DatabaseHelper {

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'my_table';
  static final table1='itemlist';
  static final table2= "tabledtls";
  static final columnId = 'id';
  static final columnTableno1 = 'tableno';

  static final columnCode = 'code';
  static final columnDesc = 'desc';
  static final columnPrice ='price';
  static final columnQuantity = 'quantity';
  static final columnTotal = 'total';
//Table details table
  static final columnTableId = 'tableid';
  static final columnKot='kot';
  static final columnType = 'type';
  static final columnDate ='date';
  static final columnTableno = 'tableno';
  static final columnWaiterno = 'waiterno';
  static final columnWaitername = 'waitername';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onConfigure: _onConfigure);
  }
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }
  // SQL code to create the database table
  Future _onCreate(Database db, int version,) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
             $columnTableId INTEGER,
            $columnCode TEXT NOT NULL,
            $columnDesc TEXT NOT NULL,
            $columnPrice INTEGER,
            $columnQuantity INTEGER,
            $columnTotal INTEGER
          )
          
          ''');
    await db.execute('''
    CREATE TABLE $table2 (
        $columnTableId INTEGER PRIMARY KEY,
        $columnKot TEXT NOT NULL,
       $columnType  TEXT NOT NULL,
       $columnDate TEXT NOT NULL,
       $columnWaiterno TEXT NOT NULL,
       $columnWaitername TEXT NOT NULL,
       $columnTableno TEXT NOT NULL
)
        
        
        ''');

  }



  // Helper methods

  // Inserts table details
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table2, row);
  }
  //insert menu details
  Future<int> insertrow(Cart cart) async {
    Database db = await instance.database;
    return await db.insert(table, {'tableid':cart.tableid,'code': cart.code, 'desc': cart.desc,'price':cart.price,'quantity':cart.quantity,'total':cart.total});
  }


  //check before insert the row
  Future<int> getcount(code,id) async {
    print('code,id');
    print(code);
    String c=code.toString();
    //   print(id);
    String tid=id.toString();


    Database db = await instance.database;
    int  count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $table WHERE $columnCode='$c' AND $columnTableId='$tid'"));
    return count;
  }
  //delete the dupilcate row based on the code
  Future<int> delcode(code) async {
    Database db = await instance.database;
    return await db.rawDelete("DELETE FROM $table WHERE $columnCode='$code'");
  }


  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.

//menu details
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }
//table details
  Future<List<dynamic>> queryTableDetails() async {
    Database db = await instance.database;
    return await db.query(table2);
  }
  //table numbers
  Future<List<Map<String, dynamic>>>queryTableNumbers() async {
    Database db = await instance.database;
    var result = await db.rawQuery("SELECT $columnTableno FROM $table2");
    return result;
  }

//get table number

  Future<int> getlastrowid() async{
    Database db = await instance.database;
    int  number = Sqflite.firstIntValue(await db.rawQuery("SELECT MAX($columnTableId) from $table2"));
    // print("last row id");
    // print(number);
    return number;
  }


  Future<int> gettableNoPerId(id) async{
    Database db = await instance.database;
    int  number = Sqflite.firstIntValue(await db.rawQuery("SELECT $columnTableno from $table2 where $columnTableId=$id"));
    // print("last row id");
    // print(number);
    return number;
  }
  Future<int>gettablecount(number) async{
    Database db = await instance.database;
    String num=number.toString();
    print(num);
    var x=await db.rawQuery('SELECT COUNT(*) FROM $table2 where $columnTableno=$num');
    int count=Sqflite.firstIntValue(x);
    print(" table no");
    print(count);
    return count;



  }
  Future<int> gettableIdPerNo(number) async{
    Database db = await instance.database;
    String num=number.toString();
    print(num);
    int  n = Sqflite.firstIntValue(await db.rawQuery("SELECT $columnTableId from $table2 where $columnTableno=$num"));
     print(" row id");
    print(n);
    return n;
  }


  //detailed items and table details based on table id
  Future<List<Map<String, dynamic>>> queryCheckOutDetails() async {
    Database db = await instance.database;
    var result= await db.rawQuery('select $table.$columnId,$table2.$columnTableId, $table.$columnDesc,$table.$columnPrice,$table.$columnQuantity,$table.$columnTotal from $table2,$table where $table2.$columnTableId=$table.$columnTableId');
    return result;
  }
  Future<List<Map<String, dynamic>>> queryCheckOutDetailsPerId(id) async {
    Database db = await instance.database;

    var result= await db.rawQuery('select $table.$columnId,$table2.$columnTableId, $table.$columnCode,$table.$columnDesc,$table.$columnPrice,$table.$columnQuantity,$table.$columnTotal from $table2,$table where $table2.$columnTableId=$table.$columnTableId AND $table.$columnTableId=$id');
    return result;
  }
  //item details per tableno
  Future<List<Map<String, dynamic>>> queryDetails(number) async {
    Database db = await instance.database;

    String s=number.toString();
    print('tableno');
    print(s);
    var result= await db.rawQuery('select $table.$columnId,$table2.$columnTableId,$table2.$columnTableno,$table.$columnCode, $table.$columnDesc,$table.$columnPrice,$table.$columnQuantity,$table.$columnTotal '
        'from $table2,$table where $table2.$columnTableId=$table.$columnTableId AND $table2.$columnTableno=$s');
    return result;
  }
  //table details per tableno
  Future<List<Map<String, dynamic>>>queryTableDetailsPerTno(number) async {
    Database db = await instance.database;
    String s = number.toString();
    var result = await db.rawQuery(
        'select * from $table2 where $columnTableno=$s');
    return result;
  }
//last inserted table details
  Future<List<Map<String,dynamic>>> querylastinsertedTableDetails() async {
    Database db = await instance.database;
    var result = await db.rawQuery("SELECT * FROM $table where $columnTableId='id'");
    return result;
  }


  Future<List<Map<String, dynamic>>>getItems() async {
    Database db = await instance.database;
    var result = await db.rawQuery('SELECT * FROM $table');
    return result;
  }


  Future<int> getquantity(code,id) async{
    print('code,id');
    print(code);
    String c=code.toString();
    //   print(id);
    String tid=id.toString();

    Database db = await instance.database;
    int  quantity = Sqflite.firstIntValue(await db.rawQuery("SELECT $columnQuantity FROM $table where $columnCode='$c' AND $columnTableId='$tid'"));
    print("database");
    print(quantity);
    return quantity;
  }
  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    var x=await db.rawQuery('SELECT COUNT(*) FROM $table');
    int count=Sqflite.firstIntValue(x);
    print(count);
    return count;
  }
  Future<int> queryRowCountperid(id) async {
    Database db = await instance.database;
    String tid=id.toString();
    var x=await db.rawQuery("SELECT COUNT(*) FROM $table where $columnTableId='$tid'");
    int count=Sqflite.firstIntValue(x);
    print(count);
    return count;
  }


  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row,id) async {
    Database db = await instance.database;
    int i=id;
    print("tableid");
    print(i);
    String code = row[columnCode];
    print(code);
    int qty=row[columnQuantity];
    print(qty);
    int tot= row[columnTotal];
    print(tot);
    return await db.rawUpdate("UPDATE $table SET $columnQuantity=$qty,$columnTotal=$tot WHERE code='$code' AND $columnTableId=$i");
    //return await db.rawUpdate(sql)
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    print("id");
    print(id);
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
  Future<int> del(String code) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnCode = ?', whereArgs: [code]);
  }
  Future<int> deleterow(int tableid,String code) async {
    Database db = await instance.database;
     print("tabid,code");
     print(tableid);
     print(code);
    return await db.delete(table, where: '$columnCode = ? AND $columnTableId=?', whereArgs: [code,tableid]);
  }


//delete all item dtls
  Future<int> deleteall() async {
    Database db = await instance.database;
    // await db.delete(table2);
    return await db.delete(table);

  }
//delete items per tableno
  Future<int> deleteItemsPerTableNo(number) async {
    print(number);
    Database db = await instance.database;
    return await db.delete(table2, where: '$columnTableno = ?', whereArgs: [number]);
  }
  //del all table dtls
  Future<int> deletetable() async {
    Database db = await instance.database;
    // await db.delete(table2);
    return await db.delete(table2);

  }
  Future<int> calculateTotal() async {
    var db = await instance.database;
    int result= Sqflite.firstIntValue( await db.rawQuery("SELECT SUM($columnTotal) as Total FROM $table"));
    print(result);
    return result;
  }
  Future<int> calculateTotalperid(id) async {
    var db = await instance.database;
    String tid=id.toString();
    int result= Sqflite.firstIntValue( await db.rawQuery("SELECT SUM($columnTotal) as Total FROM $table where $columnTableId='$tid'"));
    print(result);
    return result;
  }

}
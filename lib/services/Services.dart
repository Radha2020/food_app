import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:food/model/items.dart';
import 'package:food/model/waiters.dart';
import 'package:food/database_helper.dart';

class Services {
  static Future<String> addRemote(tableno) async {
    print(tableno);
    final dbHelper = DatabaseHelper.instance;
    await new Future.delayed(const Duration(seconds: 5));
    // final allRows =await dbHelper.queryTableDetails();
    final allRows = await dbHelper.queryTableDetailsPerTno(tableno);
    // final allRows1=await dbHelper.queryCheckOutDetails();
    final allRows1 = await dbHelper.queryDetails(tableno);

    print('query KOT details:');
    String jsonUser = jsonEncode(allRows);
    print(jsonUser);
    print('query Item details:');

    String jsonUser1 = jsonEncode(allRows1);
    print(jsonUser1);
    String url = 'http://hospital.impelcreations.co.in/hosp/Api/placetable';
    String url1 = 'http://hospital.impelcreations.co.in/hosp/Api/placeitems';

    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      http.Response response =
      await http.post(url, headers: headers, body: jsonUser);
      http.Response response1 =
      await http.post(url1, headers: headers, body: jsonUser1);

      print(response.statusCode);
      print(response1.statusCode);

      print(response.body.toString());

      var data = jsonDecode(response.body);
      var data1 = jsonDecode(response1.body);

      String status = data["status"];
      String status1 = data["status"];

      if (status == "success" && status1 == "success") {
        print(response.body.toString());
        print(response1.body.toString());
        return status;
      }
    } catch (err) {
      print('Caught error: $err');
      return err;
    }
  }

  static Future<List<Items>> fetchData() async {
    print("fetching data");
    String url = 'http://hospital.impelcreations.co.in/hosp/Api/flutitems';
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print(response.toString());
        List<Items> items = parseItems(response.body);
        return items;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<Waiters>> fetchwaiters() async {
    print("fetching waiters");
    String url = 'http://hospital.impelcreations.co.in/hosp/Api/flutwaiters';
    //  String url = 'http://192.168.43.63/hosp/Api/flutwaiters';

    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      http.Response response = await http.get(url, headers: headers);
      print(response.body.toString());
      if (response.statusCode == 200) {
        var jsonBody = response.body;
        var jsonData = json.decode(jsonBody);
        print(jsonData);
        //     return jsonData;

        // print(response.toString());
        List<Waiters> waiters = parseWaiters(response.body);
        // List<Waiters> waiters=[];
        //  for(var u in jsonData){
        //  print(u);
        //   Waiters w = Waiters(u[""]);
        //     waiters.add(w);
        //  }
        return waiters;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Waiters> parseWaiters(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Waiters>((json) => Waiters.fromJson(json)).toList();
  }

  static List<Items> parseItems(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Items>((json) => Items.fromJson(json)).toList();
  }
}

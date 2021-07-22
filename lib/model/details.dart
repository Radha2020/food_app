import 'package:food/database_helper.dart';

class Details {
  int tableid;
  String kot;
  String tableno;
  String date;
  String waitername;





  Details(this.tableid,this.kot,this.date,this.waitername,this.tableno);

  Details.fromMap(Map<String, dynamic> map) {
    tableid=map['tableid'];
    kot=map['kot'];
    date=map['date'];
    tableno=map['tableno'];
    waitername=map['waitername'];


  }

/*  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId:id,
      DatabaseHelper.columnTableId:tableid,
      DatabaseHelper.columnCode: code,
      DatabaseHelper.columnDesc:desc,
      DatabaseHelper.columnPrice:price,
      DatabaseHelper.columnQuantity:quantity,
      DatabaseHelper.columnTotal:total
      //   DatabaseHelper.columnMiles: miles,
    };
  }*/
}

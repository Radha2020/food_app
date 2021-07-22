import 'package:food/database_helper.dart';

class Cart {
  int id;
  int tableid;
  String code;
  String desc;
  int price;
  int quantity;
  int total;

  Cart(this.id,this.tableid,this.code,this.desc,this.price,this.quantity,this.total);

  Cart.fromMap(Map<String, dynamic> map) {
    id=map['id'];
    tableid=map['tableid'];
    code=map['code'];
    desc=map['desc'];
    price=map['price'];
    quantity=map['quantity'];
    total=map['total'];
  }

  Map<String, dynamic> toMap() {
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
  }
}

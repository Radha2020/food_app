
class Items{
  final String id;
  final String code;
  final String desc;
  final String price;
  int counter =1;
  bool isAdded=true;
  int itemcount=0;
  bool ShouldVisible=true;
  Items({this.id,this.code,this.desc,this.price});

  factory Items.fromJson(Map<String, dynamic> json){
    return  new Items(
        id: json['id'] as String,
        code: json['code'] as String,
        desc: json['desc'] as String,
        price: json['price'] as String
    );
  }
}

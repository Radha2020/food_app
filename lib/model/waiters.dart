class Waiters{
  final String id;
  final String waitername;
  Waiters({this.id,this.waitername});

  factory Waiters.fromJson(Map<String, dynamic> json){
   return  new Waiters(
        id: json['id'] as String,
        waitername: json['waitername'] as String,
           );
  }

  dynamic toJson() => {'id': id, 'name': waitername};

  @override
  String toString() {
    return toJson().toString();
  }
}

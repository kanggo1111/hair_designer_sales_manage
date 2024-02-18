import 'dart:convert';
/// id : "20240218124905520"
/// date : "2024-02-03"
/// type : "지명"
/// count : 2
/// price : 56000

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? date, 
      String? type, 
      int? count, 
      int? price,}){
    _id = id;
    _date = date;
    _type = type;
    _count = count;
    _price = price;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _date = json['date'];
    _type = json['type'];
    _count = json['count'];
    _price = json['price'];
  }
  String? _id;
  String? _date;
  String? _type;
  int? _count;
  int? _price;

  String? get id => _id;
  String? get date => _date;
  String? get type => _type;
  int? get count => _count;
  int? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['date'] = _date;
    map['type'] = _type;
    map['count'] = _count;
    map['price'] = _price;
    return map;
  }

}
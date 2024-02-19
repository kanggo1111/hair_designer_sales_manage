import 'dart:convert';
/// lastInputMode : false

Config configFromJson(String str) => Config.fromJson(json.decode(str));
String configToJson(Config data) => json.encode(data.toJson());
class Config {
  Config({
      bool? lastInputMode,}){
    _lastInputMode = lastInputMode;
}

  Config.fromJson(dynamic json) {
    _lastInputMode = json['lastInputMode'];
  }
  bool? _lastInputMode;

  bool? get lastInputMode => _lastInputMode;
  set lastInputMode(bool? lastInputMode) => _lastInputMode = lastInputMode;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lastInputMode'] = _lastInputMode;
    return map;
  }

}
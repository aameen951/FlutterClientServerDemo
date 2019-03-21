import 'dart:convert' as convert;

class DeserilizationError extends Error {
  String message;
  DeserilizationError(this.message);
}

class Deserializer
{
  static dynamic fromStr(String data)
  {
    return convert.json.decode(data);
  }
  static T readProperty<T>(Map<String, dynamic> data, String key, [bool allowNull=true])
  {
    if(!data.containsKey(key))throw DeserilizationError("Property '$key' doesn't exists");
    dynamic value = data[key];
    if(allowNull && value == null){/* nothing to do */}
    else if(!(value is T))throw DeserilizationError("Property '$key' has the wrong type");
    return value as T;
  }
  static Map<String, dynamic> toMap(dynamic obj)
  {
    if(!(obj is Map<String, dynamic>))throw DeserilizationError("Expected an object");
    return obj as Map<String, dynamic>;
  }
  static List<dynamic> toArr(dynamic obj)
  {
    if(!(obj is List<dynamic>))throw DeserilizationError("Expected an array");
    return obj as List<dynamic>;
  }
  static Map<String, dynamic> strToMap(String jsonStr) => toMap(fromStr(jsonStr));
  static List<dynamic> strToArr(String jsonStr) => toArr(fromStr(jsonStr));
}


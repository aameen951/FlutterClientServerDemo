import 'dart:convert' as convert;

class DeserilizationError extends Error {
  DeserilizationError();
}
class Deserializer
{
  static dynamic fromStr(String data)
  {
    return convert.json.decode(data);
  }
  static T readProperty<T>(Map<String, dynamic> data, String key)
  {
    if(!data.containsKey(key))throw DeserilizationError();
    dynamic value = data[key];
    if(!(value is T))throw DeserilizationError();
    return value as T;
  }
  static Map<String, dynamic> toMap(dynamic obj)
  {
    if(!(obj is Map<String, dynamic>))throw DeserilizationError();
    return obj as Map<String, dynamic>;
  }
  static List<dynamic> toArr(dynamic obj)
  {
    if(!(obj is List<dynamic>))throw DeserilizationError();
    return obj as List<dynamic>;
  }
  static Map<String, dynamic> strToMap(String jsonStr) => toMap(fromStr(jsonStr));
  static List<dynamic> strToArr(String jsonStr) => toArr(fromStr(jsonStr));
}



import 'package:flutter/services.dart';
import 'package:flutter_client/modules/json_deserializer.dart';

void reloadI18n() async
{
  var i18nData = await rootBundle.loadString("i18n/ar.json");
  i18nLoad(i18nData);
}

void visitor(String preKey, dynamic node, void add(String key, String value))
{
  if(node is Map<String, dynamic>)
  {
    node.forEach((k, v){
      var key = preKey != null ? preKey + "." + k : k;
      if(v is String)
      {
        add(key, v);
      }
      else
      {
        visitor(key, v, add);
      }
    });
  }
  else
  {
    throw Error();
  }
}

Map<String, dynamic> table;
void i18nLoad(String dataStr)
{
  var data = Deserializer.fromStr(dataStr);
  table = Map<String, String>();
  visitor(null, data, (k, v) => table[k] = v);
}
String i18n(String name)
{
  return table.containsKey(name) ? table[name] : "<i18n:$name>";
}
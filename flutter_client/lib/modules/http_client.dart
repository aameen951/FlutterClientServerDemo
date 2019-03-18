import 'package:flutter_client/modules/json_deserializer.dart';
import 'dart:io' as io;
import 'dart:convert' as convert;

const DOMAIN = '192.168.1.10';

class ApiResponse
{
  String status;
  dynamic body;

  ApiResponse.fromMap(Map<String, dynamic> data)
  {
    status = Deserializer.readProperty<String>(data, "status").toLowerCase();
    body = Deserializer.readProperty<dynamic>(data, "body");
  }
}
Future<ApiResponse> makeRequest(String method, String path, dynamic data) async
{
  var client = io.HttpClient();
  var request = await client.open(method, DOMAIN, 80, 'fcsd/'+path);
  request.headers.contentType = io.ContentType("application", "json");
  request.write(convert.jsonEncode(data));
  var response = await request.close();
  var contentType = response.headers.contentType;
  if(contentType.mimeType == "application/json")
  {
    var responseDataStr = await response.transform(convert.utf8.decoder).join();
    try {
      var response = ApiResponse.fromMap(Deserializer.strToMap(responseDataStr));
      return response;
    } on FormatException catch(e) {
    }
  }
  client.close(force: true);
  return null;
}


import 'package:flutter_client/modules/json_deserializer.dart';
import 'dart:io' as io;
import 'dart:convert' as convert;

const DOMAIN = '192.168.1.10';


enum ApiResponseType
{
  Ok,
  FormError,
  Error
}
class ApiResponseFormError
{
  String name;
  dynamic params;
  static ApiResponseFormError fromMap(Map<String, dynamic> map)
  {
    var result = ApiResponseFormError();
    result.name = Deserializer.readProperty<String>(map, "name");
    result.params = Deserializer.readProperty<dynamic>(map, "params");
    return result;
  }
}
class ApiResponseError
{
  String name;
  String message;
  dynamic params;
  static ApiResponseError fromMap(Map<String, dynamic> map)
  {
    var result = ApiResponseError();
    result.name = Deserializer.readProperty<String>(map, "name");
    result.message = Deserializer.readProperty<String>(map, "message");
    result.params = Deserializer.readProperty<dynamic>(map, "params");
    return result;
  }
}
class ApiResponse<T>
{
  ApiResponseType type;
  T data; // valid when type == Ok
  ApiResponseFormError formError; // valid when type == FormError
  ApiResponseError error; // // valid when type == Error

  static ApiResponse<T> fromMap<T>(dynamic obj, [T reader(dynamic obj)])
  {
    var map = Deserializer.toMap(obj);
    var result = ApiResponse<T>();
    var typeStr = Deserializer.readProperty<String>(map, "type").toLowerCase();
    if(typeStr == 'ok')
    {
      result.type = ApiResponseType.Ok;
      result.data = reader(Deserializer.readProperty<dynamic>(map, "body"));
    }
    else if(typeStr == 'form_error')
    {
      result.type = ApiResponseType.FormError;
      result.formError = ApiResponseFormError.fromMap(Deserializer.readProperty<Map<String, dynamic>>(map, "body"));
    }
    else if(typeStr == 'error')
    {
      result.type = ApiResponseType.Error;
      result.error = ApiResponseError.fromMap(Deserializer.readProperty<Map<String, dynamic>>(map, "body"));
    }
    else
    {
      throw DeserilizationError("Unknown response type '$typeStr'");
    }
    return result;
  }
}
ApiResponse<T> protocolError<T>(String name, String message, [Map<String, dynamic> params])
{
  var error = <String, dynamic>{
    "type": "error",
    "body": <String, dynamic>{
      "name": name,
      "message": message,
      "params": params,
    },
  };
  return ApiResponse.fromMap(error);
}

Future<ApiResponse<T>> makeRequest<T>(String method, String path, dynamic requestData, [T reader(dynamic obj)]) async
{
  var client = io.HttpClient();
  client.idleTimeout = Duration(seconds: 2);
  client.connectionTimeout = Duration(seconds: 2);
  var url = Uri(scheme: "http", host:DOMAIN, port: 80, path:'fcsd/'+path);
  var request = await client.openUrl(method, url);
  request.headers.contentType = io.ContentType("application", "json");
  request.write(String.fromCharCodes(convert.JsonUtf8Encoder().convert(requestData)));
  var response = await request.close();
  var contentType = response.headers.contentType;
  ApiResponse<T> result;
  if(contentType == null)
  {
    result = protocolError("NON_JSON_RESPONSE", "Server did not specify the Content-Type header");
  }
  else if(contentType?.mimeType != "application/json")
  {
    result = protocolError("NON_JSON_RESPONSE", "Server responeded with payload that isn't json (got: ${contentType.mimeType})");
  }
  else
  {
    var responseDataStr = await response.transform(convert.utf8.decoder).join();
    try {
      var responseMap = Deserializer.strToMap(responseDataStr);
      result = ApiResponse.fromMap<T>(responseMap, reader ?? (x)=>x);
    } on DeserilizationError catch(e) {
      result = protocolError<T>(
        "BAD_RESPONSE_FORMAT", 
        "Server responeded with payload that has bad/unexpected format",
        <String, dynamic>{
          "exception": e,
          "payload":responseDataStr,
        }
      );
    }
  }
  client.close(force: false);
  return result;
}


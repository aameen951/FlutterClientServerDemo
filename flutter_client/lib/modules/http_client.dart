import 'package:flutter/material.dart';
import 'package:flutter_client/config.dart';
import 'package:flutter_client/modules/json_deserializer.dart';
import 'package:flutter_client/widgets/response_error.dart';
import 'dart:io' as io;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';


const responseType_Ok            = "ok";
const responseType_NotAuthorized = "not_authorized";
const responseType_FormError     = "form_error";
const responseType_ServerError   = "server_error";
const responseType_BadRequest    = "bad_request";
const responseType_ClientError   = "client_error";
const responseType_ConnectionError   = "connection_error";

enum ActionResultType
{
  Ok,
  FormError,
  FieldError,

  Unknown,
}
class ActionResult
{
  ActionResultType type;
  
  bool get isOk => type == ActionResultType.Ok;
  bool get isFormError => type == ActionResultType.FormError;

  dynamic data;

  ActionResult.ok(dynamic data)
  {
    type = ActionResultType.Ok;
    this.data = data;
  }
  ActionResult.formError(dynamic data)
  {
    type = ActionResultType.FormError;
    this.data = data;
  }
}

class ApiResponse
{
  String type;
  dynamic data;

  ApiResponse(this.type, this.data);

  static ApiResponse fromMap(dynamic obj)
  {
    var map = Deserializer.toMap(obj);
    var type = Deserializer.readProperty<String>(map, "type").toLowerCase();
    var data = Deserializer.readProperty(map, "body");
    return ApiResponse(type, data);
  }
}

io.HttpClient _httpClient;
String _httpClientAuthToken;
const _httpClientAuthTokenStorageKey = "AUTH_SESSION_TOKEN";

void initHttpClient() async
{
  _httpClient = io.HttpClient();
  _httpClient.idleTimeout = Duration(seconds: 10);
  var pref = await SharedPreferences.getInstance();
  String token = pref.getString(_httpClientAuthTokenStorageKey);
  _httpClientAuthToken = token;
}
void setHttpClientAuthToken(String token) async
{
  _httpClientAuthToken = token;
  var pref = await SharedPreferences.getInstance();
  await pref.setString(_httpClientAuthTokenStorageKey, token);
}
Uri buildUrl(String path)
{
  String scheme = configHttpServerUseSecureProtocol ? "https" : "http";
  String fullPath = configHttpServerPrefix != null ? "$configHttpServerPrefix/$path" : path;
  var url = Uri(scheme: scheme, host:configHttpServerDomain, port:configHttpServerPort, path:fullPath);
  return url;
}
Future<ApiResponse> makeRequest(String method, String path, dynamic requestData) async
{
  ApiResponse result;
  var url = buildUrl(path);
  try{
    var request = await _httpClient.openUrl(method, url);
    request.headers.set("Content-Type", io.ContentType("application", "json").toString());
    if(_httpClientAuthToken != null)
    {
      request.headers.set("Authorization", "Bearer $_httpClientAuthToken");
    }
    if(requestData == null)requestData = <String, dynamic>{};
    var requestStrData = String.fromCharCodes(convert.JsonUtf8Encoder().convert(requestData));
    if(method != 'GET' && method != 'HEAD')
    {
      request.write(requestStrData);
    }
    var response = await request.close();
    var contentType = response.headers.contentType;
    if(contentType == null)
    {
      result = ApiResponse(responseType_ClientError, <String, dynamic>{
        'name': "NON_JSON_RESPONSE",
        'message': "Server did not specify the Content-Type header",
      });
    }
    else if(contentType?.mimeType != "application/json")
    {
      result = ApiResponse(responseType_ClientError, <String, dynamic>{
        'name': "NON_JSON_RESPONSE",
        'message': "Server response isn't json (got: ${contentType.mimeType})",
      });
    }
    else
    {
      var responseDataStr = await response.transform(convert.utf8.decoder).join();
      try {
        print("[$method] => $path : $requestStrData");
        print(" => $responseDataStr");
        var responseMap = Deserializer.strToMap(responseDataStr);
        result = ApiResponse.fromMap(responseMap);
      } on DeserilizationError catch(e) {
        result = ApiResponse(responseType_ClientError, <String, dynamic>{
          'name': "BAD_RESPONSE",
          'message': "Server response has bad/unexpected format",
          'response': responseDataStr,
          'exception': e,
        });
      }
    }
  } on Exception catch(e){
    return ApiResponse(responseType_ConnectionError, <String, dynamic>{
      'exception': e,
    });
  }
  return result;
}
Future<ApiResponse> makeGetRequest(String path, dynamic requestData) async
  => makeRequest("GET", path, requestData);
Future<ApiResponse> makePostRequest(String path, dynamic requestData) async
  => makeRequest("POST", path, requestData);


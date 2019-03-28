


import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/modules/json_deserializer.dart';

class AuthLoginResponse
{
  String token;
  static AuthLoginResponse fromMap(dynamic obj)
  {
    var map = Deserializer.toMap(obj);
    var result = AuthLoginResponse();
    result.token = Deserializer.readProperty<String>(map, 'token');
    return result;
  }
}

Future<ApiResponse<AuthLoginResponse>> sessionLogin(String email, String password) async
{
  var requestData = <String, dynamic>{
    "email":email,
    "password":password,
  };
  // send the request, and specify the class the represent the response
  var response = await makeRequest("POST", "auth/login", requestData, AuthLoginResponse.fromMap);
  return response;
}

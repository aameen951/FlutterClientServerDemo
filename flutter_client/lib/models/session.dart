import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/modules/json_deserializer.dart';


class UserStatus
{
  String email;

  UserStatus.fromMap(Map<String, dynamic> map)
  {
    this.email = Deserializer.readProperty<String>(map, "email");
  }
}

UserStatus _userStatus;

UserStatus sessionGetUserStatus()
{
  assert(_userStatus != null);
  return _userStatus;
}

Future<ApiResponse> sessionCheckUserStatus(RequestContext ctx) async
{
  var response = await ctx.requestGet("auth/user-status", null);
  _userStatus = null;
  if(response.type == responseType_Ok)
  {
    _userStatus = UserStatus.fromMap(response.data);
  }
  return response;
}

Future<ApiResponse> sessionLogin(RequestContext ctx, String email, String password) async
{
  var requestData = <String, dynamic>{
    "email":email,
    "password":password,
  };
  var response = await ctx.requestPost("auth/login", requestData);
  if(response.type == responseType_Ok)
  {
    var token = response.data['token'];
    setHttpClientAuthToken(token);
    _userStatus = UserStatus.fromMap(response.data['user_status']);
  }
  return response;
}
Future<ApiResponse> sessionLogout(RequestContext ctx) async
{
  var response = await ctx.requestPost("auth/logout", null);
  setHttpClientAuthToken(null);
  return response;
}

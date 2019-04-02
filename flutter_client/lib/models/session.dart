import 'package:flutter_client/modules/http_client.dart';



Future<ApiResponse> sessionUserStatus(RequestContext ctx) async
{
  var request = await ctx.requestGet("auth/user-status", null);
  return request;
}

Future<ApiResponse> sessionLogin(RequestContext ctx, String email, String password) async
{
  var requestData = <String, dynamic>{
    "email":email,
    "password":password,
  };
  var response = await ctx.requestPost("auth/login", requestData);
  if(response.type == ApiResponseType.Ok)
  {
    var token = response.data['token'];
    setHttpClientAuthToken(token);
  }
  return response;
}
Future<ApiResponse> sessionLogout(RequestContext ctx) async
{
  var response = await ctx.requestPost("auth/logout", null);
  setHttpClientAuthToken(null);
  return response;
}

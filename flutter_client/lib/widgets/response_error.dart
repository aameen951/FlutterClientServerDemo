

import 'package:flutter/material.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/modules/i18n.dart';

class WdFormError extends StatelessWidget
{
  final ApiResponse response;

  WdFormError(this.response);

  @override
  Widget build(BuildContext context) {
    Widget result = Container();
    if(response != null && response.type == responseType_FormError)
    {
      String errorName = response.data['name'];
      dynamic errorParams = response.data['params'];
      result = Container(
        child: Text(i18n("error.$errorName"), style: TextStyle(color: Colors.red)),
      );
    }
    return result;
  }
}

class WdResponseError extends StatelessWidget
{
  final ApiResponse response;

  WdResponseError(this.response);

  @override
  Widget build(BuildContext context) {
    Widget result;
    if(response == null || 
      response.type == responseType_Ok || 
      response.type == responseType_FormError || 
      response.type == responseType_NotAuthorized
    )
    {
      result = Container();
    }
    else if(response.type == responseType_BadRequest)
    {
      String name = response.data['name'];
      String message = response.data['message'];

      result = Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Bad Request: $name", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Text(message, style: TextStyle(color: Colors.red)),
          ],
        ),
      );
    }
    else if(response.type == responseType_ServerError)
    {
      String name = response.data['name'];
      String message = response.data['message'];
      String trace = response.data['trace'];

      result = Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Server Error: $name", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Text(message, style: TextStyle(color: Colors.red)),
          ],
        ),
      );
    }
    else if(response.type == responseType_ClientError)
    {
      String name = response.data['name'];
      String message = response.data['message'];
      String responseBody = response.data.containsKey('response') ? response.data['response'] : null;
      Exception exception = response.data.containsKey('exception') ? response.data['exception'] : null;

      result = Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Client Error: $name", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Text(message, style: TextStyle(color: Colors.red)),
            Text(exception.toString(), style: TextStyle(color: Colors.red)),
            Text("Response:", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Text(responseBody, style: TextStyle(color: Colors.red)),
          ],
        ),
      );
    }
    else if(response.type == responseType_ConnectionError)
    {
      Exception exception = response.data['exception'];

      result = Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Connection Error", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Text(exception.toString(), style: TextStyle(color: Colors.red)),
          ],
        ),
      );
    }
    return result;
  }
}
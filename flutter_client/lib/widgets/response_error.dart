

import 'package:flutter/material.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/modules/i18n.dart';

class WdResponseError extends StatelessWidget
{
  final ApiResponse response;
  WdResponseError(this.response);

  @override
  Widget build(BuildContext context) {
    if(response?.type == ApiResponseType.FormError)
    {
      var r = response.formError;
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Text(i18n("errors.${r.name}"),
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        )
      );
    }
    if(response?.type == ApiResponseType.Error)
    {
      var r = response.error;
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(r.name, 
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            r.message != null ? Text(r.message,
              style: TextStyle(
                color: Colors.red,
              ),
            ) : Container(),
            r.params != null ? Text(r.params.toString(),
              style: TextStyle(
                color: Colors.red,
              ),
            ) : Container(),

          ]
        ,)
      );
    }

    return Container();
  }
}
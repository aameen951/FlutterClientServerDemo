import 'package:flutter/material.dart';
import 'package:flutter_client/models/session.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/modules/json_deserializer.dart';
import 'package:flutter_client/pages/home.dart';
import 'package:flutter_client/pages/login.dart';
import 'package:flutter_client/widgets/response_error.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key key}) : super(key: key);

  @override
  IntroPageState createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {

  RequestContext rCtx = RequestContext();

  void checkStatus() async {
    setState(() {});

    var response = await sessionCheckUserStatus(rCtx);
    if(response.type == responseType_Ok)
    {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => HomePage()));
    }
    else if(response.type == responseType_NotAuthorized)
    {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => LoginPage()));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 16),
                  Text(
                    "مقدمة",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),

                  SizedBox(height: 16),
                  rCtx.errorWidget(),
                  SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text("التالي"),
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(10),
                      textColor: Colors.white,
                      onPressed: checkStatus,
                    ),
                  ),

                  SizedBox(height: 16),

                  rCtx.isLoading ? CircularProgressIndicator() : Container(),

                ],
              ),
            )
          )
        ),
      )
    );
  }
}

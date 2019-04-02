
import 'package:flutter/material.dart';
import 'package:flutter_client/models/session.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/pages/intro.dart';

class HomePage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
{

  RequestContext rCtx = RequestContext();
  
  void logout()async
  {
    await sessionLogout(rCtx);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => IntroPage()), (r) => r is IntroPage);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("Hello, user!"),
          RaisedButton(
            onPressed: logout,
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }
}
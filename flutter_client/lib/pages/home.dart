
import 'package:flutter/material.dart';
import 'package:flutter_client/models/session.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/modules/i18n.dart';
import 'package:flutter_client/modules/include.dart';
import 'package:flutter_client/pages/customers.dart';
import 'package:flutter_client/pages/intro.dart';
import 'package:flutter_client/widgets/include.dart';

class HomePage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
{
  ApiResponse lastResponse;
  void logout()async
  {
    lastResponse = await sSession.logUserOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => IntroPage()), (r) => r is IntroPage);
  }
  @override
  Widget build(BuildContext context) {
    return WdPage(
      title: "page.home.title",
      child: DataListener(
        models: [sSession],
        builder: (context){
          return SingleChildScrollView(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: <Widget>[
                Text("Hello, <${sSession.status.email}>"),

                SizedBox(height: 16),

                FlatButton(
                  child: Text(i18n("page.customers.title")),
                  textColor: Colors.blueAccent,
                  onPressed: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => CustomersPage()));
                  },
                ),

                SizedBox(height: 16),

                RaisedButton(
                  onPressed: logout,
                  child: Text(i18n("command.logout")),
                ),
                sSession.isLoggingOut ? CircularProgressIndicator() : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
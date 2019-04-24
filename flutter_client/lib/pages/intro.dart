import 'package:flutter/material.dart';
import 'package:flutter_client/models/session.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/modules/include.dart';
import 'package:flutter_client/pages/home.dart';
import 'package:flutter_client/pages/login.dart';
import 'package:flutter_client/widgets/include.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key key}) : super(key: key);

  @override
  IntroPageState createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  ApiResponse lastResponse;

  void checkStatus() async {
    var response = await sSession.checkUserStatus();
    lastResponse = response;
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
  }

  @override
  Widget build(BuildContext context) {
    return WdPage(
      title: null,
      child: Center(
        child: DataListener(
          models: [sSession],
          builder: (context){
            return Column(
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
                WdResponseError(lastResponse),
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
                sSession.isCheckingStatus ? CircularProgressIndicator() : Container(),
              ],
            );
          },
        ),
      )
    );
  }
}

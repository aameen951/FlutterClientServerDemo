import 'package:flutter/material.dart';
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

class AuthUserStatusResponse
{
  String email;
  static AuthUserStatusResponse fromMap(dynamic obj)
  {
    var map = Deserializer.toMap(obj);
    var result = AuthUserStatusResponse();
    result.email = Deserializer.readProperty<String>(map, "email");
    return result;
  }
}
class IntroPageState extends State<IntroPage> {
  bool isLoading = false;
  ApiResponse response;

  void checkStatus() async {
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (ctx) => LoginPage()));
    setState(() {
      response = null;
      isLoading = true; 
    });

    var request = await makeRequest("GET", "auth/user-status", null, AuthUserStatusResponse.fromMap);
    if(request.type == ApiResponseType.Ok)
    {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => HomePage()));
    }
    else if(request.type == ApiResponseType.Error && request.error.name == "ERR_AUTH_UNAUTHORIZED")
    {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => LoginPage()));
    }
    else
    {
      setState((){
        response = request;
      });
    }

    setState(() {
      isLoading = false;
    });
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
                // mainAxisAlignment: MainAxisAlignment.center,
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
                  WdResponseError(response),
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

                  isLoading ? CircularProgressIndicator() : Container( ),

                ],
              ),
            )
          )
        ),
      )
    );
  }
}

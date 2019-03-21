import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/modules/i18n.dart';
import 'package:flutter_client/modules/json_deserializer.dart';
import 'package:flutter_client/pages/register.dart';
import 'package:flutter_client/widgets/response_error.dart';
import 'package:flutter_client/widgets/text_box.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

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

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormFieldState<String>> _emailKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<WdPasswordBoxState> _passwordKey = GlobalKey<WdPasswordBoxState>();

  bool isLoading = false;
  ApiResponse lastResponse;

  void login() async
  {
    // set loading to true
    setState(() {
      lastResponse = null;
      isLoading = true;
    });
    // request data
    var requestData = <String, dynamic>{
      "email":_emailKey.currentState.value,
      "password":_passwordKey.currentState.value,
    };
    // send the request, and specify the class the represent the response
    var response = await makeRequest("POST", "auth/login", requestData, AuthLoginResponse.fromMap);
    setState(() {lastResponse = response;});
    if(response.type == ApiResponseType.Ok)
    {
      // read the token from the response
      print(response.data.token);
    }
    // set loading to false
    setState(() {isLoading = false;});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                SizedBox(height:100),

                Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height:16),

                WdTextBox(_emailKey, "الإيميل", Icons.email),

                SizedBox(height:16),

                WdPasswordBox(_passwordKey, "كلمة المرور"),
                
                SizedBox(height:16),
                WdResponseError(lastResponse),
                SizedBox(height:16),

                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("الدخول"),
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(10),
                    textColor: Colors.white,
                    onPressed: login,
                  ),
                ),

                SizedBox(height:12),

                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("الدخول"),
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(10),
                    textColor: Colors.white,
                    onPressed: ()async{
                      rootBundle.evict("i18n/ar.json");
                      var i18nData = await rootBundle.loadString("i18n/ar.json");
                      i18nLoad(i18nData);
                    },
                  ),
                ),

                SizedBox(height:12),
                isLoading ? CircularProgressIndicator(
                ) : Row( ),

                FlatButton(
                  child: Text("حساب جديد", style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.bold)),
                  textColor: Theme.of(context).primaryColor,
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx)=>RegisterPage())
                    );
                  },
                ),

              ],
            )
          )
        )
      )
    );
  }
}

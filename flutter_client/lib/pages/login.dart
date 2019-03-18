import 'package:flutter/material.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/pages/register.dart';
import 'package:flutter_client/widgets/text_box.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormFieldState<String>> _emailKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordKey = GlobalKey<FormFieldState<String>>();
  bool isLoading = false;

  void login()async
  {
    var requestData = <String, dynamic>{
      "email":_emailKey.currentState.value,
      "password":_emailKey.currentState.value,
    };
    setState(() {isLoading = true;});
    var response = await makeRequest("POST", "auth/login", requestData);
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
                
                SizedBox(height:40),

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

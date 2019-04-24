import 'package:flutter/material.dart';
import 'package:flutter_client/models/session.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/pages/home.dart';
import 'package:flutter_client/pages/register.dart';
import 'package:flutter_client/widgets/include.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormFieldState<String>> _emailKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<WdPasswordBoxState> _passwordKey = GlobalKey<WdPasswordBoxState>();

  final rCtx = new RequestContext();

  void login() async
  {
    setState(() {});
    var email = _emailKey.currentState.value;
    var password = _passwordKey.currentState.value;
    var response = await sessionLogin(rCtx, email, password);
    if(response.type == responseType_Ok)
    {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => HomePage()));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WdPage(
      title: null,
      child:SingleChildScrollView(
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
            rCtx.errorWidget(),
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

            rCtx.isLoading ? CircularProgressIndicator(
            ) : Container( ),

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
    );
  }
}

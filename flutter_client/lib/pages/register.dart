import 'package:flutter/material.dart';
import 'package:flutter_client/widgets/text_box.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormFieldState<String>> _emailKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<WdPasswordBoxState> _passwordKey = GlobalKey<WdPasswordBoxState>();
  final GlobalKey<WdPasswordBoxState> _confirmPasswordKey = GlobalKey<WdPasswordBoxState>();
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child:SingleChildScrollView(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Text(
                    "حساب جديد",
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
                  WdPasswordBox(_confirmPasswordKey, "تأكيد كلمة المرور"),
                  SizedBox(height:16),

                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text("إنشاء"),
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(10),
                      textColor: Colors.white,
                      onPressed: (){
                      },
                    ),
                  ),

                ],
              )
            )
          )
        )
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormFieldState<String>> _emailKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _confirmPasswordKey = GlobalKey<FormFieldState<String>>();
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

                  TextFormField(
                    key: _emailKey,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.all(0),
                      labelText: "الإيميل",
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),

                  SizedBox(height:16),
                  
                  TextFormField(
                    key: _passwordKey,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.all(0),
                      labelText: "كلمة المرور",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        child:Container(
                          padding: EdgeInsets.symmetric(vertical:8, horizontal: 14),
                          child:Icon(hidePassword ? Icons.visibility : Icons.visibility_off)
                        ),
                        onTap: (){setState(() {
                          hidePassword = !hidePassword;
                        });},
                      )
                    ),
                    obscureText: hidePassword,
                  ),

                  SizedBox(height:16),

                  TextFormField(
                    key: _confirmPasswordKey,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.all(0),
                      labelText: "تأكيد كلمة المرور",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        child:Container(
                          padding: EdgeInsets.symmetric(vertical:8, horizontal: 14),
                          child:Icon(hidePassword ? Icons.visibility : Icons.visibility_off)
                        ),
                        onTap: (){setState(() {
                          hidePassword = !hidePassword;
                        });},
                      )
                    ),
                    obscureText: hidePassword,
                  ),

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

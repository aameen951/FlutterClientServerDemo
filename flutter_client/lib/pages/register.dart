import 'package:flutter/material.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/widgets/response_error.dart';
import 'package:flutter_client/widgets/text_box.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormFieldState<String>> _emailKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<WdPasswordBoxState> _passwordKey = GlobalKey<WdPasswordBoxState>();

  final rCtx = new RequestContext();

  void register() async
  {
    setState(() {});

    var requestData = <String, dynamic>{
      "email":_emailKey.currentState.value,
      "password":_passwordKey.currentState.value,
    };
    var response = await rCtx.requestPost("auth/register", requestData);
    setState(() {});
    if(response.type == ApiResponseType.Ok)
    {
      Navigator.of(context).pop();
    }
  }

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
                  
                  rCtx.errorWidget(),
                  SizedBox(height:16),

                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text("إنشاء"),
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(10),
                      textColor: Colors.white,
                      onPressed: register,
                    ),
                  ),
                  SizedBox(height:12),

                  rCtx.isLoading ? CircularProgressIndicator(
                  ) : Container( ),

                ],
              )
            )
          )
        )
      ),
    );
  }
}

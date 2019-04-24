import 'package:flutter/material.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/modules/include.dart';
import 'package:flutter_client/widgets/response_error.dart';
import 'package:flutter_client/widgets/include.dart';

class UserManagerStore with ListenableData
{
  static const REGISTERING_NEW_USER = 'registering-new-user';
  
  get isRegisteringNewUser => isLoading(REGISTERING_NEW_USER);

  Future<ApiResponse> registerNewUser(String email, String password) async
  {
    setLoading(REGISTERING_NEW_USER);
    var requestData = <String, dynamic>{
      "email":email,
      "password":password,
    };
    var response = await makePostRequest("auth/register", requestData);
    clearLoading();
    return response;
  }
}
final sUserManager = UserManagerStore();

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}
class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormFieldState<String>> _emailKey = GlobalKey<FormFieldState<String>>();
  final GlobalKey<WdPasswordBoxState> _passwordKey = GlobalKey<WdPasswordBoxState>();

  ApiResponse lastResponse;
  void register() async
  {
    setState(() {});

    var email = _emailKey.currentState.value;
    var password = _passwordKey.currentState.value;

    var response = await sUserManager.registerNewUser(email, password);
    lastResponse = response;
    if(response.type == responseType_Ok)
    {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WdPage(
      title: null,
      child: DataListener(
        models: [sUserManager],
        builder: (context){
          return Center(
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
                  
                  WdFormError(lastResponse),
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

                  sUserManager.isRegisteringNewUser ? CircularProgressIndicator(
                  ) : Container( ),
                ],
              )
            )
          );
        },
      )
    );
  }
}

import 'package:flutter_client/modules/include.dart';

class UserStatus
{
  String email;

  UserStatus.fromMap(Map<String, dynamic> map)
  {
    this.email = Deserializer.readProperty<String>(map, "email");
  }
}
class SessionStore with ListenableData
{
  UserStatus status;

  static const CHECKING_STATUS = 'checking-status';
  static const LOGGING_IN = 'logging-in';
  static const LOGGING_OUT = 'logging-out';

  get isCheckingStatus => isLoading(CHECKING_STATUS);
  get isLoggingIn => isLoading(LOGGING_IN);
  get isLoggingOut => isLoading(LOGGING_OUT);

  Future<ApiResponse> checkUserStatus() async
  {
    setLoading(CHECKING_STATUS);
    var response = await makeGetRequest("auth/user-status", null);
    status = null;
    if(response.type == responseType_Ok)
    {
      status = UserStatus.fromMap(response.data);
    }
    clearLoading();
    return response;
  }

  Future<ApiResponse> logUserIn(String email, String password) async
  {
    setLoading(LOGGING_IN);
    var requestData = <String, dynamic>{
      "email":email,
      "password":password,
    };
    var response = await makePostRequest("auth/login", requestData);
    if(response.type == responseType_Ok)
    {
      var token = response.data['token'];
      setHttpClientAuthToken(token);
      status = UserStatus.fromMap(response.data['user_status']);
    }
    clearLoading();
    return response;
  }
  Future<ApiResponse> logUserOut() async
  {
    setLoading(LOGGING_OUT);
    var response = await makePostRequest("auth/logout", null);
    setHttpClientAuthToken(null);
    clearLoading();
    return response;
  }
}

final sSession = SessionStore();



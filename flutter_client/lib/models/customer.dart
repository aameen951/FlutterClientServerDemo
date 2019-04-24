import 'package:flutter_client/modules/include.dart';

class Customer
{
  String id;
  String name;
  String mobile;

  Customer.fromMap(Map<String, dynamic> map)
  {
    id = Deserializer.readProperty<String>(map, 'id');
    name = Deserializer.readProperty<String>(map, 'name');
    mobile = Deserializer.readProperty<String>(map, 'mobile');
  }
}
class CustomerStore with ListenableData
{
  List<Customer> _customers;

  List<Customer> get customers => _customers;

  static const LOADING_FIRST_TIME = "loading-first-time";
  static const UPDATING = "updating";
  static const CREATING = "creating";

  bool get isLoadingFirstTime => isLoading(LOADING_FIRST_TIME);
  bool get isUpdating => isLoading(UPDATING);
  bool get isCreating => isLoading(CREATING);

  Future<ActionResult> create(String name, String mobile) async
  {
    setLoading(CREATING);
    var requestData = <String, dynamic>{
      'name': name,
      'mobile': mobile,
    };
    var response = await makePostRequest('customer/create', requestData);
    ActionResult result;
    if(response.type == responseType_Ok)
    {
      var c = Customer.fromMap(response.data);
      _customers.add(c);
      result = ActionResult.ok(c);
    }
    else if(response.type == responseType_FormError)
    {
      result = ActionResult.formError(response);
    }
    clearLoading();
    return result;
  }

  Future<List<Customer>> getAll() async
  {
    setLoading(_customers == null ? LOADING_FIRST_TIME : UPDATING);
    var requestData = <String, dynamic>{
    };
    var response = await makeGetRequest('customers', requestData);
    var result = List<Customer>();
    if(response.type == responseType_Ok)
    {
      var list = response.data as List<dynamic>;
      list.forEach((c){
        result.add(Customer.fromMap(c));
      });
    }
    _customers = result;
    clearLoading();
    return result;
  }
}
var sCustomers = CustomerStore();


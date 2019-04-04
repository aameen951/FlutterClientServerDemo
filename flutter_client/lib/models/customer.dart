
import 'package:flutter_client/modules/data_listener.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/modules/json_deserializer.dart';

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
  List<Customer> _customers = [];

  List<Customer> get customers => _customers;

  Future<ActionResult> create(String name, String mobile) async
  {
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
      notify();
      result = ActionResult.ok(c);
    }
    else if(response.type == responseType_FormError)
    {
      result = ActionResult.formError(response);
    }
    return result;
  }

  Future<List<Customer>> getAll() async
  {
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
    notify();
    return result;
  }
}
var sCustomers = CustomerStore();


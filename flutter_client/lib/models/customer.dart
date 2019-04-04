
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

  int _count = 0;
  get count => _count;
  set count(int c) {
    _count = c;
    notify();
  }
  List<Customer> get customers => _customers;

  Future<Customer> create(RequestContext ctx, String name, String mobile) async
  {
    var requestData = <String, dynamic>{
      'name': name,
      'mobile': mobile,
    };
    var response = await ctx.requestPost('customer/create', requestData);
    Customer result;
    if(response.type == responseType_Ok)
    {
      result = Customer.fromMap(response.data);
      _customers.add(result);
    }
    return result;
  }

  Future<List<Customer>> getAll(RequestContext ctx) async
  {
    var requestData = <String, dynamic>{
    };
    var response = await ctx.requestGet('customers', requestData);
    var result = List<Customer>();
    if(response.type == responseType_Ok)
    {
      var list = response.data as List<dynamic>;
      list.forEach((c){
        result.add(Customer.fromMap(c));
      });
    }
    _customers = result;
    return result;
  }
}
var sCustomers = CustomerStore();


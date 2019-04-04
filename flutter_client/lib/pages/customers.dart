

import 'package:flutter/material.dart';
import 'package:flutter_client/models/customer.dart';
import 'package:flutter_client/modules/data_listener.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/modules/i18n.dart';

class CreateCustomerPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => CreateCustomerPageState();

}
class CreateCustomerPageState extends State<CreateCustomerPage>
{
  var nameCtrl = TextEditingController();
  var mobileCtrl = TextEditingController();

  RequestContext rCtx = RequestContext();

  void create() async
  {
    setState((){});
    var name = nameCtrl?.text;
    var mobile = mobileCtrl?.text;
    var result = await sCustomers.create(rCtx, name, mobile);
    if(result != null)
    {
      print(result.id);
      print(result.name);
      print(result.mobile);
      Navigator.of(context).pop();
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n("page.create-customer.title")),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: i18n("data.customer.name"),
                  ),
                  controller: nameCtrl,
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: i18n("data.customer.mobile"),
                  ),
                  controller: mobileCtrl,
                ),
                SizedBox(height: 16),
                rCtx.errorWidget(),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text(i18n("command.create")),
                    onPressed: create,
                  )
                ),
                SizedBox(height: 16),
                rCtx.isLoading ? CircularProgressIndicator() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomersPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => CustomersPageState();

}
class CustomersPageState extends State<CustomersPage>
{
  var _key = GlobalKey<RefreshIndicatorState>();
  RequestContext rCtx = RequestContext();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n("page.customers.title")),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: RefreshIndicator(
          key: _key,
          onRefresh: ()async{
            // _customers = await sCustomers.getAll(rCtx);
            // setState(() {});
          },
          child: DataListener(
            models: [],
            builder: (ctx){
              return Text("Hello ${sCustomers.count}");
            }
          ),
          // _child: _customers != null && _customers.length > 0 ? ListView.builder(
          //   itemCount: _customers.length,
          //   itemBuilder: (ctx, idx){
          //     return Text("Name: ${_customers[idx].name}");
          //   },
          // ) : ListView(
          //   children: <Widget>[
          //     rCtx.errorWidget(),
          //     Text(i18n("general.no-results"), textAlign: TextAlign.center),
          //   ],
          // ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: i18n("page.create-customer.title"),
        onPressed: (){
          sCustomers.count++;
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (ctx) => CreateCustomerPage()));
        },
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_client/models/customer.dart';
import 'package:flutter_client/modules/data_listener.dart';
import 'package:flutter_client/modules/i18n.dart';
import 'package:flutter_client/widgets/include.dart';

class CreateCustomerPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => CreateCustomerPageState();
}
class CreateCustomerPageState extends State<CreateCustomerPage>
{
  var nameCtrl = TextEditingController();
  var mobileCtrl = TextEditingController();

  dynamic formError;

  void create() async
  {
    setState((){
      formError = null;
    });
    var name = nameCtrl?.text;
    var mobile = mobileCtrl?.text;
    var result = await sCustomers.create(name, mobile);
    if(result.isOk)
    {
      Navigator.of(context).pop();
    }
    else if(result.isFormError)
    {
      setState((){
        formError = result.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WdPage(
      title: "page.create-customer.title",
      child:DataListener(
        models: [sCustomers],
        builder: (ctx) => SingleChildScrollView(
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
              WdFormError(formError),
              SizedBox(height: 16),

              Container(
                width: double.infinity,
                child: RaisedButton(
                  child: Text(i18n("command.create")),
                  onPressed: create,
                )
              ),
              SizedBox(height: 16),
              sCustomers.isCreating ? Center(child:CircularProgressIndicator()) : Container(),
            ],
          ),
        ),
      )
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

  @override
  void initState(){
    super.initState();
    sCustomers.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return WdPage(
      title:"page.customers.title",
      padding: EdgeInsets.zero,
      child:RefreshIndicator(
        key: _key,
        onRefresh: ()async{
          await sCustomers.getAll();
        },
        child: DataListener(
          models: [sCustomers],
          builder: (ctx){
            return sCustomers.isLoadingFirstTime ? Center(
              child:CircularProgressIndicator()
            ) : ListView.builder(
              itemCount: sCustomers.customers.length,
              itemBuilder: (ctx, idx){
                var c = sCustomers.customers[idx];
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(c.name),
                  onTap: (){},
                );
              },
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: i18n("page.create-customer.title"),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => CreateCustomerPage()));
        },
      ),
    );
  }
}

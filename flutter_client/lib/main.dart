import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client/modules/http_client.dart';
import 'package:flutter_client/modules/i18n.dart';
import 'package:flutter_client/pages/intro.dart';

void main() async {
  initHttpClient();
  runApp(MyApp());
}

class WdHotReloadNotifier extends StatefulWidget
{
  final Function callback;
  final Widget child;
  WdHotReloadNotifier({this.callback, this.child});
  @override
  State<StatefulWidget> createState() => WdHotReloadNotifierState();
}
class WdHotReloadNotifierState extends State<WdHotReloadNotifier>
{
  @override
  void initState() {
    super.initState();
    this.widget.callback();
  }
  @override
  void reassemble() async
  {
    super.reassemble();
    await this.widget.callback();
  }
  @override
  Widget build(BuildContext context) {
    return this.widget.child;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WdHotReloadNotifier(
      callback: () async {
        reloadI18n();
      },
      child:MaterialApp(
        title: 'FlutterClientServerDemo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: IntroPage(),
      ),
    );
  }
}

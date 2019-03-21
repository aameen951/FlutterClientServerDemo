import 'package:flutter/material.dart';

class WdTextBox extends StatelessWidget {
  final Key subkey;
  final String label;
  final IconData icon;
  final TextEditingController controller;
  WdTextBox(this.subkey, this.label, this.icon, {this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: subkey,
      controller: controller,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(0),
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

class WdPasswordBox extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  WdPasswordBox(Key key, this.label, {this.controller}) : super(key: key);

  @override
  WdPasswordBoxState createState() => WdPasswordBoxState();
}
class WdPasswordBoxState extends State<WdPasswordBox> {
  bool hidePassword = true;
  final GlobalKey<FormFieldState<String>> _fieldState = GlobalKey<FormFieldState<String>>();

  String get value => _fieldState.currentState.value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _fieldState,
      controller: widget.controller,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(0),
        labelText: widget.label,
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
    );
  }
}


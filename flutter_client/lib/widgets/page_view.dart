
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_client/modules/i18n.dart';

const defaultPadding = EdgeInsets.all(20);

class WdPage extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget floatingActionButton;
  final EdgeInsets padding;

  WdPage({
    this.title, 
    this.child,
    this.floatingActionButton,
    this.padding=defaultPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: this.title != null ? AppBar(
          title: Text(i18n(this.title)),
        ) : null,
        body: SafeArea(
          child:Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: this.padding,
              child: child,
            )
          )
        ),
        floatingActionButton: this.floatingActionButton,
      )
    );
  }
}

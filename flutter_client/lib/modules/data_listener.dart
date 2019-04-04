

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ListenableData implements Listenable
{
  final Set<VoidCallback> _listeners = Set<VoidCallback>();
  bool signaled = false;
  
  @override
  void addListener(listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(listener) {
    _listeners.remove(listener);
  }

  void notify()
  {
    if(!signaled)
    {
      signaled = true;
      scheduleMicrotask(() {
        signaled = false;
        _listeners.toList().forEach((l) => l());
      });
    }
  }
}

typedef DataListenerBuilder = Widget Function(BuildContext context);

class DataListener extends StatefulWidget
{
  final Iterable<ListenableData> models;
  final DataListenerBuilder builder;

  DataListener({
    @required this.models, 
    @required this.builder,
  });

  @override
  State<StatefulWidget> createState() => DataListenerState();
}
class DataListenerState extends State<DataListener>
{
  @override
  void initState() {
    super.initState();
    widget.models.forEach((m){m.addListener(_changeHandler);});
  }
  @override
  void didUpdateWidget(DataListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.models != oldWidget.models) {
      oldWidget.models.forEach((m){m.removeListener(_changeHandler);});
      widget.models.forEach((m){m.addListener(_changeHandler);});
    }
  }
  @override
  void dispose() {
    super.dispose();
    widget.models.forEach((m){m.removeListener(_changeHandler);});
  }
  void _changeHandler()
  {
    setState((){});
  }
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}

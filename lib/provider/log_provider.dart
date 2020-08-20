import 'package:flutter/material.dart';
import 'package:sup/api/log_service.dart';
import 'package:sup/model/log.dart';
import 'package:provider/provider.dart';

class LogProvider extends StatelessWidget {
  final Widget child;
  LogProvider({this.child});

  @override
  Widget build(BuildContext context) {
    // provide streams to the app to watch
    return StreamProvider<List<Log>>.value(
      value: logService.asList(),
      lazy: true,
      child: child,
    );
  }
}

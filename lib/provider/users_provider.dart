import 'package:sup/model/user.dart';
import 'package:flutter/material.dart';
import 'package:sup/api/user_service.dart';
import 'package:provider/provider.dart';

class FriendProvider extends StatelessWidget {
  final Widget child;
  FriendProvider({this.child});

  @override
  Widget build(BuildContext context) {
    // provide streams to the app to watch
    return StreamProvider<List<User>>.value(
      value: userService.friendsList(),
      lazy: true,
      child: child,
    );
  }
}

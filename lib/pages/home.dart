import 'package:sup/api/user_service.dart';
import 'package:sup/model/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: UserList());
  }
}

class UserList extends StatefulWidget {
  @override
  _UserList createState() => _UserList();
}

class _UserList extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    var users = Provider.of<List<User>>(context);
    var me = Provider.of<User>(context);
    if (users == null) return Text("null");

    var sorted = users
        .where((element) => me.favUsers.contains(element.uid))
        .toList()
          ..addAll(
              users.where((element) => !me.favUsers.contains(element.uid)));
    if (users.isEmpty) return Text("empty");
    return Column(children: <Widget>[
      Container(
          //color: Colors.red,
          child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text("Score: ${me.score}"),
          Text("Sups: ${me.sendCount}")
        ],
      )),
      Expanded(
          child: Container(
              child: ListView.builder(
                  itemCount: sorted.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildRow(sorted[index], me);
                  })))
    ]);

    // return ListView.builder(
    // itemCount: sorted == null ? 1 : sorted.length + 1,
    // itemBuilder: (BuildContext context, int index) {
    //   if (index == 0) {
    //     // return the header
    //     return new Row(
    //       mainAxisSize: MainAxisSize.min,
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       children: <Widget>[
    //         Text("Score: ${me.score}"),
    //         Text("Sups: ${me.sendCount}")
    //       ],
    //     );
    //   }
    //   index -= 1;
    //   return _buildRow(sorted[index], me);
    // });
  }

  Widget _buildRow(User user, User me) {
    bool isFav = me.favUsers.contains(user.uid);

    return ListTile(
      leading: Icon(Icons.person),
      title: Text(
        "${user.name} (${user.score})",
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.pink : null,
            ),
            onPressed: () {
              if (isFav) {
                print('removed');

                userService.removeFavUser(me, user);
              } else {
                print('added');

                userService.addFavUser(me, user);
              }
            },
          ),
        ],
      ),
      onTap: () {
        if (me.sendCount > 0) {
          var sendMessage = CloudFunctions.instance.getHttpsCallable(
            functionName: "sendMessage",
          )..timeout = const Duration(seconds: 30);
          sendMessage.call({"idTo": user.uid, "idFrom": me.uid});
          SnackBar bar = SnackBar(
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: "Close",
              textColor: Colors.redAccent,
              onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
            ),
            content: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("sup sent to ${user.name}"),
                ],
              ),
            ),
          );
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(bar);
        } else {
          SnackBar bar = SnackBar(
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 10),
            action: SnackBarAction(
              label: "Close",
              textColor: Colors.redAccent,
              onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
            ),
            content: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("no more sups :("),
                ],
              ),
            ),
          );
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(bar);
        }
      },
    );
  }
}

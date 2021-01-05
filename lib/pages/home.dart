import 'package:sup/api/user_service.dart';
import 'package:sup/model/user.dart';
import 'package:flutter/material.dart';
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
        .where((element) => me.favUsers.contains(element.name))
        .toList()
          ..addAll(
              users.where((element) => !me.favUsers.contains(element.name)));
    if (users.isEmpty) return Text("empty");
    return ListView.builder(
        itemCount: sorted.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRow(sorted[index], me);
        });
  }

  Widget _buildRow(User user, User me) {
    bool isFav = me.favUsers.contains(user.name);

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
        userService.addToScore(user);
      },
    );
  }
}

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

    if (users == null) return Text("null");

    if (users.isEmpty) return Text("empty");
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRow(users[index]);
        });
  }

  Widget _buildRow(User user) {
    bool isFav = false;

    getFavStatus() {
      setState(() {
        isFav = userService.me().favUsers.contains(user.name);
        print("$isFav");
      });
    }

    return ListTile(
      leading: Icon(Icons.person),
      title: Text(
        "${user.name} (${user.score})",
      ),
      trailing: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? Colors.pink : null,
      ),
      onTap: () {
        getFavStatus();
        if (isFav) {
          userService.removeFavUser(userService.me(), user);
        } else {
          userService.addFavUser(userService.me(), user);
        }
      },
      onLongPress: () {
        userService.addToScore(user);
      },
    );
  }
}

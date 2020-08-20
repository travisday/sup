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

class UserList extends StatelessWidget {
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
    final alreadySaved = false;
    return ListTile(
      title: Text(
        "${user.name} (${user.score})",
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.pink : null,
      ),
      onTap: () {
        logService.addToScore(user);
      },
    );
  }
}

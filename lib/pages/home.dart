import 'dart:io';

import 'package:sup/api/user_service.dart';
import 'package:sup/model/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// yellow = const Color(0xfece2fff);

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
    //var me = userService.me();
    if (users == null) return Text("null");
    //userService.updateLastOnline(me);
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Icon(Icons.star, color: Colors.amberAccent),
            Text("${me.score.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 24))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            FaIcon(FontAwesomeIcons.handPeace, color: Colors.amberAccent),
            Text("${me.sendCount}", style: TextStyle(fontSize: 24))
          ]),
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
  }

  Widget _buildRow(User user, User me) {
    bool isFav = me.favUsers.contains(user.uid);
    final id = user.uid;
    final defaultURL = "https://robohash.org/$id.png?set=set1?bgset=bg3";

    fav() {
      if (isFav) {
        print('removed');

        userService.removeFavUser(me, user);
      } else {
        print('added');

        userService.addFavUser(me, user);
      }
    }

    send() {
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
    }

//https://robohash.org/{$user.id}.png?set=set1?bgset=bg3'
    return Container(
        height: 120,
        child: Card(
            elevation: 5,
            child: Row(children: [
              Expanded(
                  flex: 33,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Icon(Icons.person, size: 60),
                        CircleAvatar(
                            backgroundImage: (user.profilePic.isEmpty)
                                ? NetworkImage(defaultURL)
                                : NetworkImage(user.profilePic),
                            radius: 50)
                      ])),
              Expanded(
                  flex: 66,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(children: [
                          Text("${user.name}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ]),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      size: 20, color: Colors.amberAccent),
                                  Text(
                                    //"${bitch.toStringAsFixed(2)}",
                                    "${user.score.toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                              SizedBox(
                                //Use of SizedBox
                                width: 30,
                              ),
                              IconButton(
                                icon: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav ? Colors.amberAccent : null,
                                  size: 50,
                                ),
                                onPressed: () {
                                  fav();
                                },
                              ),
                              SizedBox(
                                //Use of SizedBox
                                width: 20,
                              ),
                              IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.solidHandPeace,
                                    color: Colors.amberAccent,
                                    size: 50,
                                  ),
                                  onPressed: () {
                                    send();
                                  }),
                            ])
                      ])),
            ])));
  }
}

// Row(
//   children: [
//     Icon(Icons.star,
//         size: 20, color: Colors.amberAccent),
//     Text(
//       //"${bitch.toStringAsFixed(2)}",
//       "${user.score.toStringAsFixed(2)}",
//       style: TextStyle(fontSize: 20),
//     )
//   ],
// )

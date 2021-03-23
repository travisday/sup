import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sup/api/auth.dart';
import 'package:sup/model/user.dart';
import 'package:sup/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<AuthState>(context).user;

    var text;
    if (user == null)
      text = 'no user';
    else if (user.name == null)
      text = 'hi ' + user.email;
    else
      text = 'hi ${user.name}!';

    return Theme(
      // Find and extend the parent theme using "copyWith".
      data: Theme.of(context).copyWith(
        textTheme: ThemeData.dark().textTheme,
        buttonTheme: ThemeData.dark().buttonTheme,
      ),
      child: Flex(direction: Axis.horizontal, children: [
        Expanded(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text(text,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                FlatButton(
                  child: Text('Log Out', style: TextStyle(fontSize: 18)),
                  onPressed: FirebaseAuth.instance.signOut,
                ),
                FlatButton(
                  child: Text('Switch Theme', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .switchTheme();
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

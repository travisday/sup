import 'package:flutter/material.dart';
import 'package:sup/pages/home.dart';
import 'package:sup/api/auth.dart';
import 'package:sup/model/user.dart';
import 'package:provider/provider.dart';
import 'package:sup/widgets/firebase_message_wrapper.dart';

class Bar extends StatelessWidget {
  final Function() onDrawerTap;

  Bar({Key key, this.onDrawerTap}) : super(key: key);

  User me = auth.getCurrentUser();

  Widget _buildHeader(BuildContext context) {
    //User me = Provider.of<User>(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(40.0),
      child: Container(
        color: Theme.of(context).canvasColor,
        padding: EdgeInsets.only(right: 16.0),
        child: Flex(
          direction: Axis.horizontal,
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              child: Icon(
                Icons.menu,
                color: Theme.of(context).disabledColor,
              ),
              onPressed: onDrawerTap,
              padding: EdgeInsets.all(0),
            ),
            Text(
              "SUP! (beta)",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildHeader(context),
        body: FirebaseMessageWrapper(Home()),
      ),
    );
  }
}

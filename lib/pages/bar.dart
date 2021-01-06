import 'package:flutter/material.dart';
import 'package:sup/pages/home.dart';
import 'package:sup/widgets/firebase_message_wrapper.dart';

class Bar extends StatelessWidget {
  final Function() onDrawerTap;

  Bar({Key key, this.onDrawerTap}) : super(key: key);

  Widget _buildHeader(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(40.0),
      child: Container(
        color: Theme.of(context).canvasColor,
        padding: EdgeInsets.only(right: 16.0),
        child: Flex(
          direction: Axis.horizontal,
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
              "SUP!",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // FlatButton(
            //   child: Icon(
            //     Icons.add,
            //     color: Theme.of(context).disabledColor,
            //   ),
            //   onPressed: onDrawerTap,
            //   padding: EdgeInsets.all(0),
            // ),
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

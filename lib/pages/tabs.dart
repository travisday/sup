import 'package:flutter/material.dart';
import 'package:fiveminutejournal/pages/home.dart';

class TabNavigator extends StatelessWidget {
  final Function() onDrawerTap;

  TabNavigator({Key key, this.onDrawerTap}) : super(key: key);

  List<List<Widget>> _getTabs(BuildContext context) {
    return [
      [Tab(text: 'SUP!'), Home()],
      // [Tab(text: 'Mood Tracker'), MoodTracker()],
    ];
  }

  Widget _buildHeader(BuildContext context) {
    var titles = _getTabs(context).map((tab) => tab[0]).toList();

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
            Expanded(
              flex: 1,
              child: TabBar(
                indicatorColor: Theme.of(context).accentColor,
                labelColor: Theme.of(context).accentColor,
                unselectedLabelColor: Theme.of(context).disabledColor,
                tabs: titles,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var tabs = _getTabs(context);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildHeader(context),
        body: TabBarView(
          // physics: NeverScrollableScrollPhysics(),
          children: tabs.map((tab) => tab[1]).toList(),
        ),
      ),
    );
  }
}

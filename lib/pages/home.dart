import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fiveminutejournal/api/log_service.dart';
import 'package:fiveminutejournal/model/log.dart';
import 'package:fiveminutejournal/widgets/text_item.dart';
import 'package:provider/provider.dart';

import 'package:fiveminutejournal/provider/theme_provider.dart';

var firstPageItems = [
  {
    "asset": "BalletDoodle.png",
    "text": "get free. get writing.",
  },
  // {
  //   "asset": "GroovyDoodle.png",
  //   "text": "",
  // },
  {
    "asset": "PettingDoodle.png",
    "text": "be kind to yourself.",
  },
  {
    "asset": "SitReadingDoodle.png",
    "text": "what's on your mind?",
  },
  // {
  //   "asset": "BikiniDoodle.png",
  //   "text": "",
  // },
  {
    "asset": "GroovySittingDoodle.png",
    "text": "breathe deep. relax.",
  },
  {
    "asset": "PlantDoodle.png",
    "text": "take a moment and appreciate nature.",
  },
  {
    "asset": "SittingDoodle.png",
    "text": "whatcha thinking about?",
  },
  {
    "asset": "CoffeeDoddle.png",
    "text": "remember: don't carry too much at once.",
  },
  {
    "asset": "IceCreamDoodle.png",
    "text": "treat yourself today. you deserve it.",
  },
  {
    "asset": "ReadingDoodle.png",
    "text": "stuck? try writing about something interesting you read.",
  },
  {
    "asset": "SleekDoodle.png",
    "text": "in a hurry lately? slow down every once in a while.",
  },
  {
    "asset": "DancingDoodle.png",
    "text": "try writing about your favorite song. how does it make you feel?",
  },
  {
    "asset": "LayingDoodle.png",
    "text": "remember to relax for a bit if you need it.",
  },
  {
    "asset": "ReadingSideDoodle.png",
    "text": "try learning something new every day. what did you learn today?",
  },
  {
    "asset": "SprintingDoodle.png",
    "text": "it's just 5 minutes. get your thoughts out and feel better.",
  },
  {
    "asset": "DogJumpDoodle.png",
    "text": "remember to take time for the things that make you happy.",
  },
  {
    "asset": "LovingDoodle.png",
    "text": "tell someone how much you love them today.",
  },
  // {
  //   "asset": "RollerSkatingDoodle.png",
  //   "text": "",
  // },
  {
    "asset": "StrollingDoodle.png",
    "text": "remember to get up and move your body. it's good for you.",
  },
  {
    "asset": "DoogieDoodle.png",
    "text": "write down a story that you'll want to remember.",
  },
  {
    "asset": "MeditatingDoodle.png",
    "text":
        "remember: just writing your thoughts down makes them much easier to deal with.",
  },
  // {
  //   "asset": "RollingDoodle.png",
  //   "text": "",
  // },
  {
    "asset": "SwingingDoodle.png",
    "text": "remember to drink water.",
  },
  // {
  //   "asset": "DumpingDoodle.png",
  //   "text": "",
  // },
  {
    "asset": "MessyDoodle.png",
    "text":
        "scattered thoughts? write them down. you'll be amazed what happens.",
  },
  // {
  //   "asset": "RunningDoodle.png",
  //   "text": "",
  // },
  {
    "asset": "UnboxingDoodle.png",
    "text": "take some time and unpack whatever you're thinking about.",
  },
  // {
  //   "asset": "FloatDoodle.png",
  //   "text": "",
  // },
  // {
  //   "asset": "MoshingDoodle.png",
  //   "text": "",
  // },
  {
    "asset": "SelfieDoodle.png",
    "text": "smile! today's your day.",
  },
  {
    "asset": "ZombieingDoodle.png",
    "text": "what's going on today? write it down.",
  },
];

var firstPageItem = firstPageItems[Random().nextInt(firstPageItems.length)];

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Logs(
        firstPageItem: firstPageItem,
      ),
    );
  }
}

class Logs extends StatelessWidget {
  final firstPageItem;

  Logs({Key key, this.firstPageItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var entries = Provider.of<List<Log>>(context);

    if (entries == null) return Text('loading...');

    return PageView.builder(
        itemCount: entries.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return _buildFirstPage(context, entries);
        });
  }

  Widget _buildFirstPage(BuildContext context, List<Log> entries) {
    var isDark =
        Provider.of<ThemeProvider>(context).currentTheme == MyThemes.dark;
    var assetsPath =
        'assets/img/${isDark ? "open-doodles-dark" : "open-doodles"}/png/';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Image(
            width: 400.0,
            // height: 400.0,
            fit: BoxFit.contain,
            image: new AssetImage(assetsPath + firstPageItem["asset"])),
        Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 144),
          child: Text(
            firstPageItem["text"],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textTheme.caption.color,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        if (entries.length > 0)
          Text(
            "(swipe for past entries) >",
            style: TextStyle(
              color: Theme.of(context).textTheme.caption.color,
              fontStyle: FontStyle.italic,
            ),
          )
      ],
    );
  }
}

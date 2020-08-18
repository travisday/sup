import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiveminutejournal/model/log.dart';
import 'package:menu/menu.dart';
import 'package:share/share.dart';

class TextItem extends StatelessWidget {
  final Log log;
  final void Function() onTap;
  final void Function() onDeletePressed;
  final double paddingTop;
  final double paddingBottom;

  const TextItem(this.log,
      {Key key,
      this.onTap,
      this.onDeletePressed,
      this.paddingTop = 16.0,
      this.paddingBottom = 16.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Menu(
      items: [
        MenuItem('delete', this.onDeletePressed),
        MenuItem("copy", () async {
          await Clipboard.setData(ClipboardData(text: log.text));
          final snackBar = SnackBar(content: Text('Copied!'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
        }),
        MenuItem('share', () => Share.share(log.text)),
      ],
      child: InkWell(
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: paddingTop,
                bottom: paddingBottom),
            child: Text(
              log.text,
              softWrap: true,
            )),
        onTap: this.onTap,
      ),
    );
  }
}

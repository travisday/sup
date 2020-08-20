import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:sup/pages/profile.dart';
import 'package:sup/pages/bar.dart';

class FancyDrawer extends StatefulWidget {
  FancyDrawer({Key key}) : super(key: key);

  @override
  _FancyDrawerState createState() => _FancyDrawerState();
}

class _FancyDrawerState extends State<FancyDrawer> {
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  // GlobalKey _keyRed = GlobalKey();
  // double _width = 10;
  // bool _onTapToClose = false;
  // bool _tapScaffold = true;
  // AnimationController _animationController;
  // Animation<Color> _bkgColor;
  // String _title = "Two";

  bool _swipe = true;
  InnerDrawerAnimation _animationType = InnerDrawerAnimation.static;
  bool _proportionalChildArea = true;
  double _horizontalOffset = 0.4;
  double _verticalOffset = 0.0;
  bool _topBottom = false;
  double _scale = 0.9;
  double _borderRadius = 50;

  @override
  void initState() {
    _getwidthContainer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color currentColor = Colors.black54;

  void _getwidthContainer() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final keyContext = _keyRed.currentContext;
    //   if (keyContext != null) {
    //     final RenderBox box = keyContext.findRenderObject();
    //     final size = box.size;
    //     setState(() {
    //       _width = size.width;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: true,
      offset: IDOffset.only(
          top: _topBottom ? _verticalOffset : 0.0,
          bottom: !_topBottom ? _verticalOffset : 0.0,
          right: _horizontalOffset,
          left: _horizontalOffset),
      scale: IDOffset.horizontal(_scale),
      borderRadius: _borderRadius,
      duration: Duration(milliseconds: 11200),
      swipe: _swipe,
      proportionalChildArea: _proportionalChildArea,
      //colorTransition: currentColor,
      leftAnimationType: _animationType,
      // rightAnimationType: _animationType,
      leftChild: Material(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(child: Profile()),
      ),
      scaffold: Container(
        color: Theme.of(context).canvasColor,
        child: SafeArea(
          bottom: false,
          child: Bar(onDrawerTap: () => _innerDrawerKey.currentState.toggle()),
        ),
      ),
    );
  }
}

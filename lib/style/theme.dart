import 'dart:ui';

import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static const Color loginGradientStart = const Color(0xFFBBDEFB);
  static const Color loginGradientEnd = const Color(0xFF90CAF9);

  static const Color brandColor = const Color(0xFFFFD740);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

import 'dart:ui';

import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static const Color loginGradientStart = const Color(0xFFC1CADA);
  static const Color loginGradientEnd = const Color(0xFF7B81C1);

  static const Color brandColor = const Color(0xFF56BCA7);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

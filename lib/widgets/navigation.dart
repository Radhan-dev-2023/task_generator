import 'package:flutter/material.dart';

void navigateToScreen(BuildContext context, Widget screen) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => screen,
    ),
  );
}

void navigatesToScreen(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => screen,
    ),
  );
}


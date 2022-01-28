import 'package:flutter/material.dart';

final myTheme = ThemeData(
  brightness: ThemeData.light().brightness,
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal,
  accentColor: Colors.cyan,
);

final myDarkTheme = ThemeData(
  brightness: ThemeData.dark().brightness,
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal[400],
  accentColor: Colors.cyan,
);

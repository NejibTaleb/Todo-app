import 'package:flutter/material.dart';
import 'package:todo_app/src/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/src/views/home.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: myTheme,
      darkTheme: myDarkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

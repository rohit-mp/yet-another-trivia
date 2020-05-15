import 'package:anotherquizapp/quiz_config_screen.dart';
import 'package:anotherquizapp/quiz_screen.dart';
import 'package:anotherquizapp/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(
    MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: QuizConfigScreen(),
      routes: <String, WidgetBuilder>{
        QuizScreen.routeName: (BuildContext context) => QuizScreen(),
        ResultScreen.routeName: (BuildContext context) => ResultScreen(),
      },
    ),
  );
}

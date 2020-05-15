import 'dart:async';

import 'package:anotherquizapp/quiz_brain.dart';
import 'package:anotherquizapp/result_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  static const String routeName = '/quizScreen';

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Widget> scoreKeeperWidget = [];
  int scoreKeeper = 0;

  List<Color> defaultColors = [];
  List<ShapeBorder> defaultShape = [];
  List<String> options;

  Timer _timer;
  int _timerValue = 1000;

  bool getOptions = true;
  bool optionChosen = false;
  bool timerRunning = true;

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _timerValue = _timerValue - 1;
        if (_timerValue <= 0) {
          _timer.cancel();
          timerRunning = false;
          scoreKeeperWidget.add(Icon(
            Icons.not_interested,
            color: Colors.blue,
            size: 24,
          ));
          defaultShape = [];
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuizBrain quizBrain = ModalRoute.of(context).settings.arguments;
    if (getOptions) {
      options = quizBrain.getCurrentQuestionOptions();
//      getOptions = false;
    }

    List<Widget> optionsWidget = [];

    for (int i = 0; i < options.length; i++) {
      if (!timerRunning && options[i] == quizBrain.getCurrentQuestionAnswer()) {
        defaultShape.add(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: BorderSide(width: 4, color: Colors.green),
          ),
        );
      } else {
        defaultShape.add(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }
      defaultColors.add(Colors.blue.shade300);
      Widget widget = Container(
        padding: EdgeInsets.all(8),
        child: ButtonTheme(
          minWidth: double.infinity,
          height: 50,
          child: RaisedButton(
            shape: defaultShape[i],
            color: defaultColors[i],
            child: Text(
              options[i],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              if (!optionChosen && timerRunning) {
                setState(() {
                  optionChosen = true;
                  _timer.cancel();
                  timerRunning = false;
                  if (options[i] == quizBrain.getCurrentQuestionAnswer()) {
                    defaultColors[i] = Colors.green;
                    scoreKeeper++;
                    scoreKeeperWidget.add(Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 30,
                    ));
                  } else {
                    defaultColors[i] = Colors.red;
                    defaultColors[options.indexOf(quizBrain.getCurrentQuestionAnswer())] = Colors.green;
                    scoreKeeperWidget.add(Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 30,
                    ));
                  }
                });
              }
            },
          ),
        ),
      );
      optionsWidget.add(widget);
    }

    if (getOptions) {
      startTimer();
      getOptions = false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Yet Another Trivia'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 10,
                child: LinearProgressIndicator(
                  value: _timerValue / 1000,
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                  backgroundColor: Colors.red,
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      (quizBrain.getCurrentQuestionNumber() + 1).toString() + '. ' + quizBrain.getCurrentQuestionText(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: optionsWidget,
                ),
              ),
              Visibility(
                visible: !timerRunning,
                child: Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 80,
                    height: 40,
                    child: OutlineButton(
                      shape: StadiumBorder(),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          optionChosen = false;
                          timerRunning = true;
                          getOptions = true;
                          defaultColors = [];
                          defaultShape = [];
                          _timerValue = 1000;

                          int ret = quizBrain.updateQuestionNumber();
                          if (ret == -1) {
                            ResultArgs resultArgs = new ResultArgs(scoreKeeper, scoreKeeperWidget);
                            Navigator.pushReplacementNamed(context, ResultScreen.routeName, arguments: resultArgs);
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: timerRunning,
                child: Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 80,
                    height: 40,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: scoreKeeperWidget,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to leave this round?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'NO',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'YES',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          );
        })) ??
        false;
  }
}

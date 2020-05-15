import 'dart:io';

import 'package:anotherquizapp/quiz_brain.dart';
import 'package:anotherquizapp/quiz_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuizConfigScreen extends StatefulWidget {
  @override
  _QuizConfigScreenState createState() => _QuizConfigScreenState();
}

class _QuizConfigScreenState extends State<QuizConfigScreen> {
  int numQuestions = 10;
  String category = 'any';
  String difficulty = 'any';
  String type = 'any';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yet Another Trivia'),
      ),
      body: Builder(
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Number of Questions:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Slider(
                      value: numQuestions.toDouble(),
                      onChanged: (newNumQuestions) {
                        setState(() {
                          numQuestions = newNumQuestions.toInt();
                        });
                      },
                      divisions: 50,
                      min: 1,
                      max: 50,
                      label: '$numQuestions',
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Category:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          value: category,
                          items: [
                            DropdownMenuItem(value: 'any', child: Text('Any'),),
                            DropdownMenuItem(value: '9', child: Text('General Knowledge'),),
                            DropdownMenuItem(child: Text('Entertainment: Books'), value: '10',),
                            DropdownMenuItem(child: Text('Entertainment: Film'), value: '11',),
                            DropdownMenuItem(child: Text('Entertainment: Music'), value: '12',),
                            DropdownMenuItem(child: Text('Entertainment: Musicals & Theatres'), value: '13',),
                            DropdownMenuItem(child: Text('Entertainment: Television'), value: '14',),
                            DropdownMenuItem(child: Text('Entertainment: Video Games'), value: '15',),
                            DropdownMenuItem(child: Text('Entertainment; Board Games'), value: '16',),
                            DropdownMenuItem(child: Text('Science & Nature'), value: '17',),
                            DropdownMenuItem(child: Text('Science: Computers'), value: '18',),
                            DropdownMenuItem(child: Text('Science: Mathematics'), value: '19',),
                            DropdownMenuItem(child: Text('Mythology'), value: '20',),
                            DropdownMenuItem(child: Text('Sports'), value: '21',),
                            DropdownMenuItem(child: Text('Geography'), value: '22',),
                            DropdownMenuItem(child: Text('History'), value: '23',),
                            DropdownMenuItem(child: Text('Politics'), value: '24',),
                            DropdownMenuItem(child: Text('Art'), value: '25',),
                            DropdownMenuItem(child: Text('Celebrities'), value: '26',),
                            DropdownMenuItem(child: Text('Animals'), value: '27',),
                            DropdownMenuItem(child: Text('Vehicles'), value: '28',),
                            DropdownMenuItem(child: Text('Entertainment: Comics'), value: '29',),
                            DropdownMenuItem(child: Text('Science: Gadgets'), value: '30',),
                            DropdownMenuItem(child: Text('Entertainent: Japanese Anime & Manga'), value: '31',),
                            DropdownMenuItem(child: Text('Entertainment: Cartoon & Animations'), value: '32',),
                          ],
                          onChanged: (newValue) {
                            setState(() {
                              category = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Type:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          value: type,
                          items: [
                            DropdownMenuItem(
                              value: 'any',
                              child: Text(
                                'Any',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'multiple',
                              child: Text('Multiple Choice'),
                            ),
                            DropdownMenuItem(
                              value: 'boolean',
                              child: Text('True or False'),
                            ),
                          ],
                          onChanged: (newValue) {
                            setState(() {
                              type = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Difficulty:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          value: difficulty,
                          items: [
                            DropdownMenuItem(
                              value: 'any',
                              child: Text('Any'),
                            ),
                            DropdownMenuItem(
                              value: 'easy',
                              child: Text('Easy'),
                            ),
                            DropdownMenuItem(
                              value: 'medium',
                              child: Text('Medium'),
                            ),
                            DropdownMenuItem(
                              value: 'hard',
                              child: Text('Hard'),
                            ),
                          ],
                          onChanged: (newValue) {
                            setState(() {
                              difficulty = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                child: ButtonTheme(
                  minWidth: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    child: Text(
                      'Let\'s Start!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    color: Colors.blue,
                    onPressed: () async {
                      try {
                        final result = await InternetAddress.lookup('google.com');
                        if (!(result.isNotEmpty && result[0].rawAddress.isNotEmpty)) {
                          throw ('No Internet Connection');
                        }
                        QuizBrain quizBrain = new QuizBrain(numQuestions, category, difficulty, type);
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: _onWillPop,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              ),
                            );
                          },
                        );
                        int ret = await quizBrain.fetchQuestions();
                        if(ret == 0){
                          Navigator.pushReplacementNamed(context, QuizScreen.routeName, arguments: quizBrain);
                        }
                        else {
                          Navigator.pop(context);
                          showInvalidResponseError(context, ret);
                        }
                      } on SocketException catch (e) {
                        print('Error: $e');
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Row(
                              children: <Widget>[
                                Container(
//                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.signal_cellular_connected_no_internet_4_bar,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                SizedBox(width: 10 ,),
                                Container(
//                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    'Could not connect to the Internet',
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
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
    return false;
  }

  void showInvalidResponseError(BuildContext context, int ret) {
    String textContent;
    print('got invalid response');

    if(ret == 1){
      textContent = 'Could not find sufficient questions.';
    } else if(ret == 2){
      textContent = 'Invalid Parameter found. Report to developer.';
    } else if(ret == 3){
      textContent = 'Session token not found. Report to developer';
    } else if(ret == 4){
      textContent = 'Questions exhausted. Report to developer';
    }
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(textContent, style: TextStyle(color: Colors.white, fontSize: 18),), backgroundColor: Colors.red,),);
  }
}

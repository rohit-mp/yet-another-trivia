import 'dart:convert';

import 'package:http/http.dart';
import 'package:html/parser.dart';


class Question {
  String _category;
  String _type;
  String _difficulty;
  String _question;
  String _correctAnswer;
  List<String> _incorrectAnswers;

  Question(String category, String type, String difficulty, String question,
      String correctAnswer, List<String> incorrectAnswers) {
    _category = category;
    _difficulty = difficulty;
    _question = question;
    _correctAnswer = correctAnswer;
    _incorrectAnswers = incorrectAnswers;
  }

  factory Question.jsonToQuestion(Map<String, dynamic> json) {
    List<String> incorrectAnswers = [];
    List<String> htmlAnswers = List<String>.from(json['incorrect_answers']);
    for(int i=0; i<htmlAnswers.length; i++){
      incorrectAnswers.add(parse(parse(htmlAnswers[i]).body.text).documentElement.text);
    }

    return Question(
      json['category'],
      json['type'],
      json['difficulty'],
      parse(parse(json['question']).body.text).documentElement.text,
      parse(parse(json['correct_answer']).body.text).documentElement.text,
      incorrectAnswers,
    );
  }

  String getType(){
    return _type;
  }
}

class QuizBrain {
  int _numQuestions;
  String _category;
  String _difficulty;
  String _type;

  List<Question> _questions = [];
  int _currentQuestionNumber;

  QuizBrain(int numQuestions, String category, String difficulty, String type) {
    _numQuestions = numQuestions;
    _category = category;
    _difficulty = difficulty;
    _type = type;

    _questions = [];
    _currentQuestionNumber = 0;
  }

  Future<int> fetchQuestions() async {
    print('prepping url');
    var url = 'https://opentdb.com/api.php';
    url += '?amount=$_numQuestions';
    if (_category != 'any') {
      url += '&category=$_category';
    }
    if (_difficulty != 'any') {
      url += '&difficuly=$_difficulty';
    }
    if (_type != 'any') {
      url += '&type=$_type';
    }
    try {
      print('getting from url');
      var jsonResponse = await get(url);
      var jsonDetails = jsonDecode(jsonResponse.body);
      var responseCode = jsonDetails['response_code'];
      if(responseCode != 0) {
        return responseCode;
        throw('Invalid Response Code');
      }
      List<dynamic> results = jsonDetails['results'];
      for(int i=0; i<_numQuestions; i++){
        _questions.add(Question.jsonToQuestion(results[i]));
      }

      return 0;
    } catch (error) {
      print('failed: $error');
    }
    return -1;
  }

  List<Question> getQuestions() {
    return _questions;
  }

  String getCurrentQuestionText(){
    return _questions[_currentQuestionNumber]._question;
  }
  String getCurrentQuestionType(){
    return _questions[_currentQuestionNumber]._type;
  }
  List<String> getCurrentQuestionOptions(){
    List<String> options = [];
    options.add(_questions[_currentQuestionNumber]._correctAnswer);
    options += _questions[_currentQuestionNumber]._incorrectAnswers;
    options.shuffle();
    return options;
  }
  String getCurrentQuestionAnswer(){
    return _questions[_currentQuestionNumber]._correctAnswer;
  }
  int getCurrentQuestionNumber(){
    return _currentQuestionNumber;
  }

  int updateQuestionNumber(){
    if(_currentQuestionNumber == _numQuestions - 1) return -1;
    _currentQuestionNumber++;
    return 0;
  }
}

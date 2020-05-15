import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultArgs {
  int scoreKeeper;
  List<Widget> scoreKeeperWidget;

  ResultArgs(int scoreKeeper, List<Widget> scoreKeeperWidget){
    this.scoreKeeper = scoreKeeper;
    this.scoreKeeperWidget = scoreKeeperWidget;
  }
}

class ResultScreen extends StatelessWidget {
  static const String routeName = '/resultScreen';

  @override
  Widget build(BuildContext context) {
    final ResultArgs args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Yet Another Trivia'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Wrap(
            children: args.scoreKeeperWidget,
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
          ),
          Container(
            child: Center(
              child: Text(
                args.scoreKeeper.toString() + '/' + args.scoreKeeperWidget.length.toString(),
                style: GoogleFonts.pangolin(
                  textStyle: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: ButtonTheme(
              minWidth: double.infinity,
              height: 60,
              child: RaisedButton(
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                onPressed: () {
                  //TODO learn to use popUntil
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

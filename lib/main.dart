import 'package:flutter/material.dart';
import 'screen/quizScreen.dart';
import 'screen/setUp.dart';
import 'screen/summary.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivia Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/setup',
      routes: {
        '/setup': (context) => SetupScreen(),
        '/quiz': (context) => QuizScreen(args: {},),
        '/summary': (context) => SummaryScreen(
              totalQuestions: 0, 
              correctAnswers: 0,
              quizResults: [],
            ),
      },
    );
  }
}

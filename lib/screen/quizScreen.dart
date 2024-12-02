import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  QuizScreen({required this.args});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int totalQuestions = 10;
  int _timeRemaining = 15;
  Timer? _timer;
  List<dynamic> questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchQuestions() async {
    final category = widget.args['category'];
    final difficulty = widget.args['difficulty'];
    final type = widget.args['type'];
    final amount = widget.args['amount'];

    final url = Uri.parse(
        'https://opentdb.com/api.php?amount=$amount&category=$category&difficulty=$difficulty&type=$type');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          questions = data['results'];
          totalQuestions = questions.length;
          isLoading = false;
          startTimer(); 
        });
      } else {
        setState(() {
    isLoading = false;
    questions = [];
  });
        throw Exception('Failed to load questions');
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error. Do not show')),
      );
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_timeRemaining < 1) {
        setState(() {
          timer.cancel();
          _showTimeUpMessage();
        });
      } else {
        setState(() {
          _timeRemaining--;
        });
      }
    });
  }

  void _showTimeUpMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Time’s up! Moving to the next question.')),
    );

    if (currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        currentQuestionIndex++;
        _timeRemaining = 15;
        startTimer();
      });
    } else {
      _timer?.cancel();
      displaySummary();
    }
  }

  void displaySummary() {
    Navigator.pushNamed(context, '/summary', arguments: {
      'score': currentQuestionIndex, // Placeholder for score
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '$_timeRemaining seconds remaining',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                LinearProgressIndicator(
                  value: currentQuestionIndex / totalQuestions,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      questions.isNotEmpty
                          ? questions[currentQuestionIndex]['question']
                          : 'No questions available.',
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                ...questions.isNotEmpty
                    ? (questions[currentQuestionIndex]['incorrect_answers'] as List<String>)
                        .map(
                          (answer) => ElevatedButton(
                            onPressed: () {
                              // Check answer logic here
                              if (currentQuestionIndex < totalQuestions - 1) {
                                setState(() {
                                  currentQuestionIndex++;
                                  _timeRemaining = 15;
                                });
                              } else {
                                displaySummary();
                              }
                            },
                            child: Text(answer),
                          ),
                        )
                        .toList()
                    : [],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (currentQuestionIndex > 0) {
                          setState(() {
                            currentQuestionIndex--;
                            _timeRemaining = 15;
                          });
                        }
                      },
                      child: Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (currentQuestionIndex < totalQuestions - 1) {
                          setState(() {
                            currentQuestionIndex++;
                            _timeRemaining = 15;
                          });
                        } else {
                          displaySummary();
                        }
                      },
                      child: Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

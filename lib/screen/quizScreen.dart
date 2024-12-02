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
  int remaining_time = 15;
  Timer? _timer;
  List<dynamic> questions = [];
  bool loading = true;
  int right = 0; //answers

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
    final url = Uri.parse("https://opentdb.com/api.php?amount=10");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          questions = data['results'];
          totalQuestions = questions.length;
          loading = false;
          startTimer();
        });
      } else {
        setState(() {
          loading = false;
          questions = [];
        });
        throw Exception('Failed to load questions');
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching questions.')),
      );
    }
  }

  void startTimer() {
    _timer?.cancel(); // Cancel any previous timer
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (remaining_time < 1) {
        setState(() {
          timer.cancel();
          displayTimeUpMSG();
        });
      } else {
        setState(() {
          remaining_time--;
        });
      }
    });
  }

  void displayTimeUpMSG() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Time’s up! Moving to the next question.')),
    );

    if (currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        currentQuestionIndex++;
        remaining_time = 15;
        startTimer();
      });
    } else {
      _timer?.cancel();
      displaySummary();
    }
  }

  void displaySummary() {
    Navigator.pushNamed(context, '/summary', arguments: {
      'right': right,
      'totalQuestions': totalQuestions,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '$remaining_time seconds remaining',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                LinearProgressIndicator(
                  value: totalQuestions > 0 ? currentQuestionIndex / totalQuestions : 0.0,
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
                Expanded(
                  child: ListView(
                    children: questions.isNotEmpty
                        ? (questions[currentQuestionIndex]['incorrect_answers'] as List<dynamic>)
                            .map((answer) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      bool isCorrect = (answer ==
                                          questions[currentQuestionIndex]['correct_answer']);
                                      if (isCorrect) {
                                        right++;
                                      }

                                      if (currentQuestionIndex < totalQuestions - 1) {
                                        setState(() {
                                          currentQuestionIndex++;
                                          remaining_time = 15;
                                          startTimer(); 
                                        });
                                      } else {
                                        displaySummary();
                                      }
                                    },
                                    child: Text(answer),
                                  ),
                                ))
                            .toList()
                        : [],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (currentQuestionIndex > 0) {
                          setState(() {
                            currentQuestionIndex--;
                            remaining_time = 15;
                            startTimer(); // 
                          });
                        }
                      },
                      child: Text('Prev'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (currentQuestionIndex < totalQuestions - 1) {
                          setState(() {
                            currentQuestionIndex++;
                            remaining_time = 15;
                            startTimer(); 
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

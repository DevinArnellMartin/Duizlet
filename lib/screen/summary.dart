import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int correctAnswers = args['correctAnswers'];
    final int totalQuestions = args['totalQuestions'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Score:',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '$correctAnswers / $totalQuestions',
              style: TextStyle(fontSize: 26),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(
                  'Thank you for taking the quiz!',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/setup', (route) => false);
                  },
                  child: Text('Setup New Quiz'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/quiz', (route) => false);
                  },
                  child: Text('Retake Quiz'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'setUp.dart';

class SummaryScreen extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<Map<String, dynamic>> quizResults;

  SummaryScreen({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.quizResults,
  });

  @override
  Widget build(BuildContext context) {
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

            // Show Detailed Results
            Expanded(
              child: ListView.builder(
                itemCount: quizResults.length,
                itemBuilder: (context, index) {
                  final questionResult = quizResults[index];
                  final isCorrect = questionResult['isCorrect'];
                  return Card(
                    child: ListTile(
                      title: Text(
                        questionResult['question'],
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text('Your Answer: ${questionResult['userAnswer']}'),
                          if (!isCorrect)
                            Text(
                              'Correct Answer: ${questionResult['correctAnswer']}',
                              style: TextStyle(color: Colors.green),
                            ),
                        ],
                      ),
                      trailing: Icon(
                        isCorrect ? Icons.check_circle : Icons.error,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Navigation Buttons
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SetupScreen()),
      (Route<dynamic> route) => false, 
    );
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


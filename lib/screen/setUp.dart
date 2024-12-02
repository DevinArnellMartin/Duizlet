import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  String? selectedCategory;
  String? selectedDifficulty;
  String? selectedType;
  String questionCount = "10";
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('https://opentdb.com/api_category.php'));
      if (response.statusCode == 200) {
        setState(() {
          categories = List<Map<String, dynamic>>.from(jsonDecode(response.body)['trivia_categories']);
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: categories.isEmpty
            ? Center(child: CircularProgressIndicator()) 
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category', style: TextStyle(fontSize: 18)),
                  DropdownButton<String>(
                    value: selectedCategory,
                    hint: Text('Select Category'),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['id'].toString(),
                        child: Text(category['name']),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 20),
                  Text('Difficulty', style: TextStyle(fontSize: 20)),
                  DropdownButton<String>(
                    value: selectedDifficulty,
                    hint: Text('Select Difficulty'),
                    onChanged: (value) {
                      setState(() {
                        selectedDifficulty = value;
                      });
                    },
                    items: ['easy', 'medium', 'hard'].map((difficulty) {
                      return DropdownMenuItem<String>(
                        value: difficulty,
                        child: Text(difficulty[0].toUpperCase() + difficulty.substring(1)),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 20),

                  Text('Type', style: TextStyle(fontSize: 18)),
                  DropdownButton<String>(
                    value: selectedType,
                    hint: Text('Select Question Type'),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    items: ['multiple', 'boolean'].map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type == 'multiple' ? 'Multiple Choice' : 'True/False'),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 20),


                  Text('Question Count', style: TextStyle(fontSize: 18)),
                  TextFormField(
                    initialValue: questionCount,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        questionCount = value;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),

                  SizedBox(height: 30),

                  // Start Quiz Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate inputs before navigating
                        if (selectedCategory != null &&
                            selectedDifficulty != null &&
                            selectedType != null &&
                            int.tryParse(questionCount) != null) {
                          Navigator.pushNamed(
                            context,
                            '/quiz',
                            arguments: {
                              'category': selectedCategory,
                              'difficulty': selectedDifficulty,
                              'type': selectedType,
                              'amount': questionCount,
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please complete all selections')),
                          );
                        }
                      },
                      child: Text('Start Quiz'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

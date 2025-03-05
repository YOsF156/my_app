import 'package:flutter/material.dart';

class ConfigurationScreen extends StatefulWidget {
  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  final List<String> questions = [
    'Do you usually get 6 hours of sleep?',
    'Do you usually read or stay busy until you eventually fall asleep?',
    'Do you have a dry mouth during the night?',
    'Do you wake up and find it hard to get back to sleep?',
  ];
  int currentQuestionIndex = 0;
  List<bool?> answers = List.filled(4, null); // Store answers for each question

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuration'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (currentQuestionIndex > 0) {
              setState(() {
                currentQuestionIndex--; // Go back to the previous question
              });
            } else {
              Navigator.pop(context); // Go back to Home if on first question
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Progress Bar (4 lines, one for each question)
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: 20,
                  height: 4,
                  decoration: BoxDecoration(
                    color: index <= currentQuestionIndex
                        ? Colors
                            .grey // Filled for completed and current questions
                        : Colors.grey[300], // Unfilled for upcoming questions
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: _buildQuestion(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion() {
    if (currentQuestionIndex >= questions.length) {
      // Shouldn't happen, but as a safeguard
      return Text('Configuration complete!');
    }

    final question = questions[currentQuestionIndex];
    final answer = answers[currentQuestionIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: answer == false
                  ? null // Disable if already selected "No"
                  : () {
                      setState(() {
                        answers[currentQuestionIndex] = false;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: answer == false
                    ? Colors.grey
                    : null, // Highlight if selected
              ),
              child: Text('NO'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: answer == true
                  ? null // Disable if already selected "Yes"
                  : () {
                      setState(() {
                        answers[currentQuestionIndex] = true;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: answer == true
                    ? Colors.grey
                    : null, // Highlight if selected
              ),
              child: Text('YES'),
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: answers[currentQuestionIndex] == null
              ? null // Disable if no answer selected
              : () {
                  if (currentQuestionIndex < questions.length - 1) {
                    setState(() {
                      currentQuestionIndex++;
                    });
                  } else {
                    // Finish configuration and navigate to Random Quote screen on Day 1
                    Navigator.pushReplacementNamed(context, '/random-quote');
                  }
                },
          child: Text(
              currentQuestionIndex == questions.length - 1 ? 'FINISH' : 'NEXT'),
        ),
      ],
    );
  }
}

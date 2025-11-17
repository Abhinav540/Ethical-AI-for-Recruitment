import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuestionPage(),
    );
  }
}

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String questionType = 'text-question';
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: questionType,
              onChanged: (value) {
                setState(() {
                  questionType = value!;
                  selectedAnswer = null;
                });
              },
              items: [
                DropdownMenuItem(
                  value: 'text-question',
                  child: Text('Text Question'),
                ),
                DropdownMenuItem(
                  value: 'image-question',
                  child: Text('Image Question'),
                ),
                DropdownMenuItem(
                  value: 'voice-question',
                  child: Text('Voice Question'),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (questionType == 'text-question') ...[
              Text(
                'What is the capital of France?',
                style: TextStyle(fontSize: 18),
              ),
            ] else if (questionType == 'image-question') ...[
              Image.network(
                'https://example.com/sample-image.jpg', // Replace with a valid image URL
                height: 200,
              ),
              SizedBox(height: 10),
              Text(
                'Identify the monument shown in the image.',
                style: TextStyle(fontSize: 18),
              ),
            ] else if (questionType == 'voice-question') ...[
              ElevatedButton(
                onPressed: playAudio,
                child: Text('Play Audio'),
              ),
              SizedBox(height: 10),
              Text(
                'Listen to the audio and answer the question.',
                style: TextStyle(fontSize: 18),
              ),
            ],
            SizedBox(height: 20),
            Text(
              'Choose an answer:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            buildAnswerOption('Option 1'),
            buildAnswerOption('Option 2'),
            buildAnswerOption('Option 3'),
            buildAnswerOption('Option 4'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitAnswer,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnswerOption(String option) {
    return ListTile(
      title: Text(option),
      leading: Radio<String>(
        value: option,
        groupValue: selectedAnswer,
        onChanged: (value) {
          setState(() {
            selectedAnswer = value;
          });
        },
      ),
    );
  }

  void submitAnswer() {
    if (selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an answer!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You selected: $selectedAnswer')),
      );
    }
  }

  void playAudio() {
    // Placeholder for audio playback functionality
    print("Playing audio...");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing audio...')),
    );
  }
}

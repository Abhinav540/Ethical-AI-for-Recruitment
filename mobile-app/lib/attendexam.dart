import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

import 'Home.dart';
import 'newhome.dart'; // Ensure this file exists

class AttendExam extends StatefulWidget {
  const AttendExam({super.key, required this.title});
  final String title;

  @override
  State<AttendExam> createState() => _AttendExamState();
}

class _AttendExamState extends State<AttendExam> {
  List<int> id_ = [];
  List<String> qus_ = [];
  List<String> type_ = [];
  int currentQuestionIndex = 0;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _answer = "";

  _AttendExamState() {
    fetchQuestions();
  }

  @override
  void initState() {
    super.initState();
    requestMicrophonePermission();
    _initializeSpeech();
  }

  /// **Request microphone permission**
  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isDenied) {
      print("❌ Microphone permission denied.");
    } else {
      print("✅ Microphone permission granted.");
    }
  }

  /// **Initialize Speech-to-Text**
  void _initializeSpeech() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize(
      onStatus: (status) => print('🎤 Speech Status: $status'),
      onError: (error) => print('⚠️ Speech Error: $error'),
    );

    if (!available) {
      print('❌ Speech recognition not available.');
    }
  }

  /// **Fetch questions from API**
  void fetchQuestions() async {
    List<int> id = [];
    List<String> qus = [];
    List<String> type = [];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = '${sh.getString('url')}/user_view_questions';
      String eid = sh.getString("eid").toString();

      var data = await http.post(Uri.parse(url), body: {"eid": eid});
      var jsondata = json.decode(data.body);
      var arr = jsondata["data"];

      for (var item in arr) {
        id.add(item['id']);
        qus.add(item['type'] == "Level 1"
            ? item['question'].toString()
            : '${sh.getString('url')}/media/${item['question']}');
        type.add(item['question'].toString());
      }

      setState(() {
        id_ = id;
        qus_ = qus;
        type_ = type;
      });
    } catch (e) {
      print("❌ Error fetching questions: $e");
    }
  }

  /// **Send answer to server**
  void sendAnswer(String ans) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String url = '${sh.getString('url')}/user_send_answer';
      String lid = sh.getString("lid").toString();

      if (id_.isEmpty || currentQuestionIndex >= id_.length) {
        print("❌ Error: Invalid question ID");
        return;
      }

      await http.post(Uri.parse(url), body: {
        "lid": lid,
        'qid': id_[currentQuestionIndex].toString(), // ✅ Fixed ID retrieval
        "ans": ans
      });

      print("✅ Answer sent successfully.");
    } catch (e) {
      print("❌ Error sending answer: $e");
    }
  }

  /// **Start listening for speech input**
  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() => _answer = result.recognizedWords);
        },
      );
    } else {
      print("❌ Speech recognition not available.");
    }
  }

  /// **Stop listening and submit answer**
  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    sendAnswer(_answer);
    _nextQuestion();
  }

  /// **Move to next question**
  void _nextQuestion() {
    if (currentQuestionIndex < qus_.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _answer = "";
      });
    } else {
      Fluttertoast.showToast(msg: "🎉 Exam Completed!");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          title: Center(
            child: Text(
              'Question ${currentQuestionIndex + 1}/${qus_.length}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: type_[currentQuestionIndex] == "Level 1"
                      ? Text(
                    "Question: ${qus_[currentQuestionIndex]}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  )
                      : Image.network(
                    qus_[currentQuestionIndex],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _startListening,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Start Listening",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _stopListening,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Stop Listening & Submit",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Your Answer: $_answer",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }
}

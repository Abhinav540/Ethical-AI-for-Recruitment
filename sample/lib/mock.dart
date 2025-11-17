import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MockInterviewScreen extends StatefulWidget {
  @override
  _MockInterviewScreenState createState() => _MockInterviewScreenState();
}

class _MockInterviewScreenState extends State<MockInterviewScreen> {
  final TextEditingController _controllert = TextEditingController();
  FlutterTts _flutterTts = FlutterTts();
  stt.SpeechToText _speechToText = stt.SpeechToText();

  late CameraController _controller;
  late List<CameraDescription> cameras;

  bool _isListening = false;
  bool _waitingForAnswer = false;
  int questionIndex = 0;

  String _currentQuestion = "Welcome to the mock interview! Click 'OK' to begin.";

  @override
  void initState() {
    super.initState();


    if (!mounted) return;
    initializeCamera();
    setState(() {});
    askQuestion(_currentQuestion);
  }
  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras[1], ResolutionPreset.medium);

    await _controller.initialize();

    if (!mounted) return;

    setState(() {});
  }

  /// **Speak the question**
  Future<void> askQuestion(String text) async {
    setState(() {
      _controllert.clear();
      _currentQuestion = text;
    });

    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  /// **Handle user answer**
  Future<void> processAnswer(String answer) async {
    setState(() {
      _waitingForAnswer = true;
    });

    fetchNextQuestion(answer);

    setState(() {
      _waitingForAnswer = false;
    });
  }

  /// **Fetch AI-generated question from backend**
  Future<void> fetchNextQuestion(String answer) async {
    setState(() {
      _waitingForAnswer = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? url = prefs.getString('url');
      String? userId = prefs.getString('lid');

      if (url == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("API URL not configured.")),
        );
        return;
      }



      final image = await _controller.takePicture();
      String img = "";

      await image.readAsBytes().then((value) {
        var bytes = Uint8List.fromList(value);
        String _encodedImage = base64Encode(bytes);
        img = _encodedImage.toString();
        // Fluttertoast.showToast(msg: "Image captured");
      }).catchError((onError) {
        // Fluttertoast.showToast(msg: "Exception");
      });

      // Send data to server
      SharedPreferences sh = await SharedPreferences.getInstance();
      // String url = sh.getString('url').toString();
      String lid = sh.getString('lid').toString();

      final urls = Uri.parse('$url/mock_interview');
      try {
        final response = await http.post(urls, body:
          // 'qid': id_[index],
          // 'lid': lid,
          // 'answer': addanswer.text,  // Send the speech-to-text result
          // 'canswer': answers_[index],
          // 'photo': img,
          {'photo': img,"user_id": userId, "answer": answer,"applicationid": prefs.getString("applicationid").toString(),"question":_currentQuestion.toString()}
        );
        if (response.statusCode == 200) {


          var data = jsonDecode(response.body);
            if (data['status'] == 'completed') {
              askQuestion("Interview completed! Thank you.");
            } else {
              askQuestion(data['question']);
            }
          } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error fetching question.")),
          );
        }

          String status = jsonDecode(response.body)['status'];
          if (status == 'ok') {
            // Fluttertoast.showToast(msg: "Answer Submitted Successfully");
          } else {
            // Fluttertoast.showToast(msg: 'Not Found');
          }
        //  else {
        //   // Fluttertoast.showToast(msg: 'Network Error');
        // }
      } catch (e) {
        // Fluttertoast.showToast(msg: e.toString());
      }


      // final response = await http.post(
      //   Uri.parse('$url/mock_interview'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({"user_id": userId, "answer": answer,"applicationid": prefs.getString("applicationid").toString(),"question":_currentQuestion.toString()}),
      // );
      //
      // if (response.statusCode == 200) {
      //   var data = jsonDecode(response.body);
      //   if (data['status'] == 'completed') {
      //     askQuestion("Interview completed! Thank you.");
      //   } else {
      //     askQuestion(data['question']);
      //   }
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Error fetching question.")),
      //   );
      // }





    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error.")),
      );
    }

    setState(() {
      _waitingForAnswer = false;
    });
  }

  /// **Start voice recognition**
  Future<void> _startListening() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) => print("STT Status: $status"),
      onError: (error) => print("STT Error: $error"),
    );

    if (available) {
      setState(() {
        _isListening = true;
      });

      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _controllert.text = result.recognizedWords;
          });
        },
      );
    }
  }

  /// **Stop voice recognition**
  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mock Interview"), backgroundColor: Colors.teal),
      body:
      Stack(
          children: [
          // Camera Preview
          if (_controller.value.isInitialized)
        Positioned.fill(
        child: CameraPreview(_controller),
    ),
    // Content on top of the camera feed
    Padding(
    padding: const EdgeInsets.all(16.0),
    child:
    Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Text(
                _currentQuestion,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

          if (questionIndex > 0)
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _controllert,
                decoration: InputDecoration(
                  hintText: "Your Answer...",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                    color: _isListening ? Colors.red : Colors.blue,
                    onPressed: () {
                      if (_isListening) {
                        _stopListening();
                      } else {
                        _startListening();
                      }
                    },
                  ),
                ),
              ),
            ),

          // **OK button only for the first question**
          if (questionIndex == 0)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  questionIndex++;
                });
                fetchNextQuestion("OK");
              },
              child: Text("OK"),
            )
          else
            ElevatedButton(
              onPressed: () {
                if (_controllert.text.isNotEmpty) {
                  processAnswer(_controllert.text);
                }
              },
              child: Text("Next"),
            ),

          if (_waitingForAnswer)
            Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
        ],
      ),)])
    );
  }

  @override
  void dispose() {


    _controller.dispose();
    super.dispose();
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:camera/camera.dart';
//
// class MockInterviewScreen extends StatefulWidget {
//   @override
//   _MockInterviewScreenState createState() => _MockInterviewScreenState();
// }
//
// class _MockInterviewScreenState extends State<MockInterviewScreen> {
//   // Text-to-Speech
//   final FlutterTts _flutterTts = FlutterTts();
//
//   // Speech Recognition
//   final stt.SpeechToText _speechToText = stt.SpeechToText();
//   bool _isListening = false;
//
//   // Face Detection
//   CameraController? _cameraController;
//   bool _isCameraInitialized = false;
//   FaceDetector _faceDetector = GoogleMlKit.vision.faceDetector(
//     FaceDetectorOptions(
//       enableClassification: true,  // Enables emotion detection
//       enableContours: false,
//     ),
//   );
//   String detectedEmotion = "Neutral";
//
//   // Question Handling
//   bool _waitingForAnswer = false;
//   int questionIndex = 0;
//   String _currentQuestion = "Welcome to the mock interview! Click 'OK' to begin.";
//   TextEditingController _answerController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//     askQuestion(_currentQuestion);
//   }
//
//   /// **Initialize Camera for Face Detection**
//   Future<void> initializeCamera() async {
//     final cameras = await availableCameras();
//     _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
//
//     await _cameraController!.initialize();
//     if (!mounted) return;
//
//     setState(() {
//       _isCameraInitialized = true;
//     });
//
//     startFaceDetection();
//   }
//
//   /// **Process Camera Frames for Face Detection**
//   void startFaceDetection() {
//     _cameraController!.startImageStream((CameraImage image) async {
//       if (_faceDetector == null) return;
//
//       final inputImage = InputImage.fromBytes(
//         bytes: image.planes[0].bytes,
//         metadata: InputImageMetadata(
//           size: Size(image.width.toDouble(), image.height.toDouble()),
//           rotation: InputImageRotation.rotation0deg,
//           format: InputImageFormat.nv21,
//           bytesPerRow: image.planes[0].bytesPerRow,
//         ),
//       );
//
//       final List<Face> faces = await _faceDetector.processImage(inputImage);
//
//       if (faces.isNotEmpty) {
//         setState(() {
//           detectedEmotion = detectEmotion(faces.first);
//         });
//       }
//     });
//   }
//
//   /// **Detect Emotion from Face**
//   String detectEmotion(Face face) {
//     if (face.smilingProbability != null) {
//       if (face.smilingProbability! > 0.7) return "Happy 😀";
//       if (face.smilingProbability! < 0.3) return "Sad 😢";
//     }
//     return "Neutral 😐";
//   }
//
//   /// **Speak the Question**
//   Future<void> askQuestion(String text) async {
//     setState(() {
//       _answerController.clear();
//       _currentQuestion = text;
//     });
//
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setPitch(1.0);
//     await _flutterTts.speak(text);
//   }
//
//   /// **Process Answer & Fetch Next Question**
//   Future<void> processAnswer(String answer) async {
//     setState(() {
//       _waitingForAnswer = true;
//     });
//
//     fetchNextQuestion(answer);
//
//     setState(() {
//       _waitingForAnswer = false;
//     });
//   }
//
//   /// **Fetch Next Question from Backend**
//   Future<void> fetchNextQuestion(String answer) async {
//     setState(() {
//       _waitingForAnswer = true;
//     });
//
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? url = prefs.getString('url');
//       String? userId = prefs.getString('lid');
//       String? vacancyId = prefs.getString('eid');  // Get Vacancy ID
//
//       if (url == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("API URL not configured.")),
//         );
//         return;
//       }
//
//       // Send answer, detected emotion, and score
//       final response = await http.post(
//         Uri.parse('$url/mock_interview'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "user_id": userId,
//           "vacancy_id": vacancyId,
//           "answer": answer,
//           "emotion": detectedEmotion,
//           "score": calculateScore(answer, detectedEmotion),  // Score Calculation
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         if (data['status'] == 'completed') {
//           askQuestion("Interview completed! Thank you.");
//         } else {
//           askQuestion(data['question']);
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error fetching question.")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Network error.")),
//       );
//     }
//
//     setState(() {
//       _waitingForAnswer = false;
//     });
//   }
//
//   /// **Calculate Score based on Emotion & Answer Length**
//   int calculateScore(String answer, String emotion) {
//     int score = answer.length ~/ 5;
//     if (emotion == "Happy 😀") score += 5;
//     if (emotion == "Sad 😢") score -= 3;
//     return score.clamp(0, 100);
//   }
//
//   /// **Start Listening for Voice Input**
//   Future<void> _startListening() async {
//     bool available = await _speechToText.initialize(
//       onStatus: (status) => print("STT Status: $status"),
//       onError: (error) => print("STT Error: $error"),
//     );
//
//     if (available) {
//       setState(() {
//         _isListening = true;
//       });
//
//       _speechToText.listen(
//         onResult: (result) {
//           setState(() {
//             _answerController.text = result.recognizedWords;
//           });
//         },
//       );
//     }
//   }
//
//   /// **Stop Listening**
//   Future<void> _stopListening() async {
//     await _speechToText.stop();
//     setState(() {
//       _isListening = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     _faceDetector.close();
//     _cameraController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Mock Interview"), backgroundColor: Colors.teal),
//       body: Column(
//         children: [
//           Expanded(child: Center(child: Text(_currentQuestion, textAlign: TextAlign.center))),
//           Text("Detected Emotion: $detectedEmotion", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           TextField(controller: _answerController, decoration: InputDecoration(hintText: "Your Answer...")),
//           ElevatedButton(onPressed: () => processAnswer(_answerController.text), child: Text("Next")),
//         ],
//       ),
//     );
//   }
// }

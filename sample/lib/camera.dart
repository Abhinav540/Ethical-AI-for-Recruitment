// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:camera/camera.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: AttendInterview(title: ""),
//     );
//   }
// }
//
// class AttendInterview extends StatefulWidget {
//   const AttendInterview({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<AttendInterview> createState() => _AttendInterviewState();
// }
//
// class _AttendInterviewState extends State<AttendInterview> {
//   late CameraController _controller;
//   late List<CameraDescription> cameras;
//   String currentQuestion = "";
//   int questionIndex = 1;
//
//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//     getData();
//   }
//
//   Future<void> initializeCamera() async {
//     cameras = await availableCameras();
//     _controller = CameraController(cameras[1], ResolutionPreset.medium);
//
//     await _controller.initialize();
//
//     if (!mounted) return;
//
//     setState(() {
//       // getData();
//
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   TextEditingController addanswer=new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Page Design'),
//       ),
//       body: Stack(
//         children: [
//           // Camera Preview
//           if (_controller.value.isInitialized)
//             Positioned.fill(
//               child: CameraPreview(_controller),
//             ),
//           // Content on top of the camera feed
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   questions_[index],
//                   style: TextStyle(
//                     fontSize: 24.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 8.0),
//                 Expanded(
//                   child: TextField(
//                     controller:addanswer ,
//                     maxLines: null, // Allows for multiline input
//                     decoration: InputDecoration(
//                       hintText: 'Answer',
//                       hintStyle: TextStyle(color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.black.withOpacity(0.5),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () async {
//
//
//
//                     final image = await _controller.takePicture();
//
//                     String img= "";
//
//                     await image.readAsBytes().then((value) {
//                       var bytes = Uint8List.fromList(value);
//                       print('reading of bytes is completed');
//
//
//                       String _encodedImage = base64Encode(bytes);
//                        img= _encodedImage.toString();
//
//
//
//                       Fluttertoast.showToast(msg: "Hi");
//                     }).catchError((onError) {
//
//                       Fluttertoast.showToast(msg: "Exception");
//                       print('Exception Error while reading audio from path:' +
//                           onError.toString());
//                     });
//
//
//
//
//
//                     // String complaint=addanswer.text;
//
//
//
//                     SharedPreferences sh = await SharedPreferences.getInstance();
//                     String url = sh.getString('url').toString();
//                     String lid = sh.getString('lid').toString();
//
//                     final urls = Uri.parse('$url/addanswer/');
//                     try {
//                       final response = await http.post(urls, body: {
//                         'qid':id_[index],
//                         'lid':lid,
//                         'answer':addanswer.text,
//                         'canswer':answers_[index],
//                         'photo':img
//
//
//
//                       });
//                       if (response.statusCode == 200) {
//                         String status = jsonDecode(response.body)['status'];
//                         if (status=='ok') {
//
//                         }
//
//                         else {
//                           Fluttertoast.showToast(msg: 'Not Found');
//                         }
//                       }
//                       else {
//                         Fluttertoast.showToast(msg: 'Network Error');
//                       }
//                     }
//                     catch (e){
//                       Fluttertoast.showToast(msg: e.toString());
//                     }
//
//
//
//
//
//                     if(index< questions_.length-1) {
//                       setState(() {
//                         index = index + 1;
//                       });
//                     }
//                     else
//                       {
//                         Fluttertoast.showToast(msg: "Question completed");
//                       }
//                     // Handle button press
//                   },
//                   child: Text('Next'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List id_ = [], questions_ = [], answers_ = [],CATEGORY_ = [];
//
//   int index=0;
//   void getData() async {
//     List id = [], Question = [], Answer = [], CATEGORY = [];
//
//     try {
//       SharedPreferences sh = await SharedPreferences.getInstance();
//       String urls = sh.getString('url').toString();
//       String iurl = sh.getString('img_url').toString();
//       String url = '$urls/userviewquestion/';
//
//       final response = await http.post(Uri.parse(url), body: {
//         'cid':sh.getString('catid').toString()
//       });
//       if (response.statusCode == 200) {
//         print(response.body);
//         String status = jsonDecode(response.body)['status'];
//         if (status == 'ok') {
//           var data = jsonDecode(response.body)['data'];
//
//           print(data);
//
//           for (int i = 0; i < data.length; i++) {
//             id.add(data[i]['id'].toString());
//             Question.add(data[i]['Questions'].toString());
//             Answer.add(data[i]['Answer'].toString());
//             CATEGORY.add(data[i]['CATEGORY'].toString());
//           }
//           setState(() {
//             id_ = id;
//             questions_ = Question;
//             answers_ = Answer;
//             CATEGORY_ = CATEGORY;
//           });
//         } else {
//           Fluttertoast.showToast(msg: "Not found");
//         }
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
// }


import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;  // Import speech_to_text

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AttendInterview(title: ""),
    );
  }
}

class AttendInterview extends StatefulWidget {
  const AttendInterview({super.key, required this.title});

  final String title;

  @override
  State<AttendInterview> createState() => _AttendInterviewState();
}

class _AttendInterviewState extends State<AttendInterview> {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  String currentQuestion = "";
  int questionIndex = 1;

  // Speech-to-text
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;  // Track if speech recognition is ongoing
  String _spokenText = "";  // Store the recognized speech text

  @override
  void initState() {
    super.initState();
    initializeCamera();
    getData();
    _initializeSpeechRecognizer();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras[1], ResolutionPreset.medium);

    await _controller.initialize();

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _initializeSpeechRecognizer() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Speech recognition is not available.");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.stop();
    super.dispose();
  }

  TextEditingController addanswer = TextEditingController();

  // Start speech recognition
  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.listen(
        onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords;
            addanswer.text = _spokenText;  // Update text field with spoken text
          });
        },
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
      }
    }
  }

  // Stop speech recognition
  void _stopListening() async {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Page Design'),
      ),
      body: Stack(
        children: [
          // Camera Preview
          if (_controller.value.isInitialized)
            Positioned.fill(
              child: CameraPreview(_controller),
            ),
          // Content on top of the camera feed
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questions_[index],
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: TextField(
                    controller: addanswer,
                    maxLines: null, // Allows for multiline input
                    decoration: InputDecoration(
                      hintText: 'Answer',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                // Speak to Text Button
                ElevatedButton(
                  onPressed: () {
                    if (_isListening) {
                      _stopListening();
                    } else {
                      _startListening();
                    }
                  },
                  child: Text(_isListening ? 'Stop Listening' : 'Speak to Text'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final image = await _controller.takePicture();
                    String img = "";

                    await image.readAsBytes().then((value) {
                      var bytes = Uint8List.fromList(value);
                      String _encodedImage = base64Encode(bytes);
                      img = _encodedImage.toString();
                      Fluttertoast.showToast(msg: "Image captured");
                    }).catchError((onError) {
                      Fluttertoast.showToast(msg: "Exception");
                    });

                    // Send data to server
                    SharedPreferences sh = await SharedPreferences.getInstance();
                    String url = sh.getString('url').toString();
                    String lid = sh.getString('lid').toString();

                    final urls = Uri.parse('$url/addanswer/');
                    try {
                      final response = await http.post(urls, body: {
                        'qid': id_[index],
                        'lid': lid,
                        'answer': addanswer.text,
                        'canswer': answers_[index],
                        'photo': img,
                      });
                      if (response.statusCode == 200) {
                        String status = jsonDecode(response.body)['status'];
                        if (status == 'ok') {
                          // Handle success
                        } else {
                          Fluttertoast.showToast(msg: 'Not Found');
                        }
                      } else {
                        Fluttertoast.showToast(msg: 'Network Error');
                      }
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }

                    addanswer.text="";
                    if (index < questions_.length - 1) {
                      setState(() {
                        index = index + 1;
                      });
                    } else {
                      Fluttertoast.showToast(msg: "Question completed");
                    }


                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List id_ = [], questions_ = [], answers_ = [], CATEGORY_ = [];
  int index = 0;

  void getData() async {
    List id = [], Question = [], Answer = [], CATEGORY = [];

    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url').toString();
      String iurl = sh.getString('img_url').toString();
      String url = '$urls/userviewquestion/';

      final response = await http.post(Uri.parse(url), body: {
        'cid': sh.getString('catid').toString()
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          var data = jsonDecode(response.body)['data'];

          for (int i = 0; i < data.length; i++) {
            id.add(data[i]['id'].toString());
            Question.add(data[i]['Questions'].toString());
            Answer.add(data[i]['Answer'].toString());
            CATEGORY.add(data[i]['CATEGORY'].toString());
          }
          setState(() {
            id_ = id;
            questions_ = Question;
            answers_ = Answer;
            CATEGORY_ = CATEGORY;
          });
        } else {
          Fluttertoast.showToast(msg: "Not found");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
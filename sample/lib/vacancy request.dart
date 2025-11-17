// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:sample/home.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewVacancyRequest extends StatefulWidget {
//   const ViewVacancyRequest({super.key, required this.title});
//   final String title;
//
//   @override
//   State<ViewVacancyRequest> createState() => _ViewVacancyRequestState();
// }
//
// class _ViewVacancyRequestState extends State<ViewVacancyRequest> {
//   List<Map<String, String>> vacancies = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadVacancies();
//   }
//
//   Future<void> loadVacancies() async {
//     try {
//       final pref = await SharedPreferences.getInstance();
//       String ip = pref.getString("url") ?? "";
//       String url = "$ip/vacancy_request";
//
//       var response = await http.post(Uri.parse(url), body: {
//
//         'lid': pref.getString("lid") ?? ""
//
//       });
//
//
//
//       var jsondata = json.decode(response.body);
//       if (jsondata['status'] == 'ok') {
//         List<Map<String, String>> fetchedVacancies = [];
//         for (var item in jsondata['data']) {
//           fetchedVacancies.add({
//             'id': item['vacancyid'].toString(),
//             'vacancyposition': item['vacancyposition'],
//             'company_name': item['comapany_name'],
//             'date': item['date'],
//             'status': item['status'],
//           });
//         }
//         setState(() {
//           vacancies = fetchedVacancies;
//         });
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   Future<void> applyForVacancy(Map<String, String> vacancy) async {
//     final sh = await SharedPreferences.getInstance();
//     String url = sh.getString("url") ?? "";
//
//     var response = await http.post(
//       Uri.parse("$url/applyvaccancy"),
//       body: {
//         'lid': sh.getString("lid") ?? "",
//         'vacancyid': vacancy['id'],
//       },
//     );
//
//     var jsondata = json.decode(response.body);
//     String status = jsondata['status'] ?? "";
//
//     if (status == "ok") {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Applied for ${vacancy['vacancyposition']}")),
//       );
//       Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Already Applied for ${vacancy['vacancyposition']}")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title, style: TextStyle(color: Colors.white)),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: vacancies.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: vacancies.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: EdgeInsets.all(10),
//             elevation: 5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ...vacancies[index].entries.map((entry) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: Row(
//                         children: [
//                           Expanded(
//                               flex: 2,
//                               child: Text(entry.key,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold))),
//                           Expanded(flex: 3, child: Text(entry.value)),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//
//
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:sample/home.dart';
// // Import your mock test page
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'mock.dart';
//
// class ViewVacancyRequest extends StatefulWidget {
//   const ViewVacancyRequest({super.key, required this.title});
//   final String title;
//
//   @override
//   State<ViewVacancyRequest> createState() => _ViewVacancyRequestState();
// }
//
// class _ViewVacancyRequestState extends State<ViewVacancyRequest> {
//   List<Map<String, String>> vacancies = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadVacancies();
//   }
//
//   Future<void> loadVacancies() async {
//     try {
//       final pref = await SharedPreferences.getInstance();
//       String ip = pref.getString("url") ?? "";
//       String url = "$ip/vacancy_request";
//
//       var response = await http.post(Uri.parse(url), body: {
//         'lid': pref.getString("lid") ?? ""
//       });
//
//       var jsondata = json.decode(response.body);
//       if (jsondata['status'] == 'ok') {
//         List<Map<String, String>> fetchedVacancies = [];
//         for (var item in jsondata['data']) {
//           fetchedVacancies.add({
//             'id': item['vacancyid'].toString(),
//             'vacancyposition': item['vacancyposition'],
//             'company_name': item['comapany_name'],
//             'date': item['date'],
//             'status': item['status'],
//           });
//         }
//         setState(() {
//           vacancies = fetchedVacancies;
//         });
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   Future<void> applyForVacancy(Map<String, String> vacancy) async {
//     final sh = await SharedPreferences.getInstance();
//     String url = sh.getString("url") ?? "";
//
//     var response = await http.post(
//       Uri.parse("$url/applyvaccancy"),
//       body: {
//         'lid': sh.getString("lid") ?? "",
//         'vacancyid': vacancy['id'],
//       },
//     );
//
//     var jsondata = json.decode(response.body);
//     String status = jsondata['status'] ?? "";
//
//     if (status == "ok") {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Applied for ${vacancy['vacancyposition']}")),
//       );
//       Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Already Applied for ${vacancy['vacancyposition']}")),
//       );
//     }
//   }
//
//   void attendMockTest(String vacancyId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MockInterviewScreen(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title, style: TextStyle(color: Colors.white)),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: vacancies.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: vacancies.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: EdgeInsets.all(10),
//             elevation: 5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ...vacancies[index].entries.map((entry) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: Row(
//                         children: [
//                           Expanded(
//                               flex: 2,
//                               child: Text(entry.key,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold))),
//                           Expanded(flex: 3, child: Text(entry.value)),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // ElevatedButton(
//                       //   onPressed: () => applyForVacancy(vacancies[index]),
//                       //   child: Text("Apply"),
//                       //   style: ElevatedButton.styleFrom(
//                       //     backgroundColor: Colors.green,
//                       //     foregroundColor: Colors.white,
//                       //   ),
//                       // ),
//                       ElevatedButton(
//
//                         onPressed: ()async {
//     //
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString('eid',item['vacancyid']);
//
//
//
//         Navigator.push(
//           context,
//
//           MaterialPageRoute(builder: (context) => MockInterviewScreen()),
//         );
//
//       },
//                         child: Text("Attend Mock Test"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sample/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mock.dart'; // Import your Mock Interview Screen

class ViewVacancyRequest extends StatefulWidget {
  const ViewVacancyRequest({super.key, required this.title});
  final String title;

  @override
  State<ViewVacancyRequest> createState() => _ViewVacancyRequestState();
}

class _ViewVacancyRequestState extends State<ViewVacancyRequest> {
  List<Map<String, String>> vacancies = [];

  @override
  void initState() {
    super.initState();
    loadVacancies();
  }

  Future<void> loadVacancies() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url") ?? "";
      String url = "$ip/vacancy_request";

      var response = await http.post(Uri.parse(url), body: {
        'lid': pref.getString("lid") ?? "",
      });

      var jsondata = json.decode(response.body);
      if (jsondata['status'] == 'ok') {
        List<Map<String, String>> fetchedVacancies = [];
        for (var item in jsondata['data']) {
          fetchedVacancies.add({
            'id': item['vacancyid'].toString(),
            'applicationid': item['applid'].toString(),
            'vacancyposition': item['vacancyposition'],
            'company_name': item['comapany_name'],
            'date': item['date'],
            'status': item['status'],
          });
        }
        setState(() {
          vacancies = fetchedVacancies;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Future<void> applyForVacancy(Map<String, String> vacancy) async {
  //   final sh = await SharedPreferences.getInstance();
  //   String url = sh.getString("url") ?? "";
  //
  //   var response = await http.post(
  //     Uri.parse("$url/applyvaccancy"),
  //     body: {
  //       'lid': sh.getString("lid") ?? "",
  //       'vacancyid': vacancy['id'],
  //     },
  //   );
  //
  //   var jsondata = json.decode(response.body);
  //   String status = jsondata['status'] ?? "";
  //
  //   if (status == "ok") {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Applied for ${vacancy['vacancyposition']}")),
  //     );
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Already Applied for ${vacancy['vacancyposition']}")),
  //     );
  //   }
  // }

  Future<void> attendMockTest(String vacancyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('eid', vacancyId);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MockInterviewScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: vacancies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: vacancies.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...vacancies[index].entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(entry.key,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Expanded(flex: 3, child: Text(entry.value)),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (vacancies[index]['status'] == 'pending')
                        ElevatedButton(
                        onPressed: () async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();

                          // Store vacancy ID
                          await prefs.setString('eid', vacancies[index]['id']!);
                          await prefs.setString('applicationid', vacancies[index]['applicationid']!);

                          // Store session ID (if available)


                          // Navigate to Mock Interview Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MockInterviewScreen()),
                          );
                        },
                        child: Text("Attend Mock Test"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

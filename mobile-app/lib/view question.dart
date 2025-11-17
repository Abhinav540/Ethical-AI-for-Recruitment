

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sample/home.dart';
import 'package:sample/vacancy%20request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewVacancyPage extends StatefulWidget {
  const ViewVacancyPage({super.key, required this.title});
  final String title;

  @override
  State<ViewVacancyPage> createState() => _ViewVacancyPageState();
}

class _ViewVacancyPageState extends State<ViewVacancyPage> {
  List<Map<String, String>> vacancies = [];

  _ViewVacancyPageState() {
    loadVacancies();
  }

  Future<void> loadVacancies() async {
    try {
      final pref = await SharedPreferences.getInstance();
      String ip = pref.getString("url").toString();
      String url = "$ip/viewvacancy";
      print(url);

      var response = await http.get(Uri.parse(url));
      var jsondata = json.decode(response.body);

      if (jsondata['status'] == 'ok') {
        List<Map<String, String>> fetchedVacancies = [];
        for (var item in jsondata['data']) {
          fetchedVacancies.add({
            'id': item['id'].toString(),
            'Position': item['vacancyposition'],
            'HR Name': item['Hrid.name'],
            'Qualification': item['qualification'],
            'Salary': item['salary'],
            'Experience': item['experiencedetails'],
            'Posted On': item['date'],
            'Due Date': item['duedate'],
            'Vacancies': item['numberofvacancy'],
          });
        }
        setState(() {
          vacancies = fetchedVacancies;
        });
      }
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  Future<void> applyForVacancy(Map<String, String> vacancy) async {

    // Fluttertoast.showToast(msg: "-----"+vacancy.toString());
    // Handle the apply action (e.g., navigate to another page or send a request)
    // print("Applying for: ${vacancy['Position']}");

    final sh = await SharedPreferences.getInstance();
    String url = sh.getString("url").toString();
    print("okkkkkkkkkkkkkkkkk");
    var data = await http.post(
        Uri.parse(url+"applyvaccancy"),
        body: {'lid':sh.getString("lid").toString(),
          "vaccancyid":vacancy['id'],
        });
    var jasondata = json.decode(data.body);
    String status=jasondata['status'].toString();
    if(status=="ok") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Applied for ${vacancy['Position']}")),
      );

      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => ViewVacancyRequest(title: '',)));


    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Already Applied for ${vacancy['Position']}")),
      );

    }





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
      body: ListView.builder(
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
                          Expanded(flex: 2, child: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 3, child: Text(entry.value)),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => applyForVacancy(vacancies[index]),
                      child: Text("Apply"),
                    ),
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

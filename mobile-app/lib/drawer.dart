
import 'package:flutter/material.dart';
import 'package:sample/send%20complaint&view%20complaint.dart';
import 'package:sample/vacancy%20request.dart';
import 'package:sample/view%20profile.dart';
import 'package:sample/view%20request%20status.dart';
import 'package:sample/view_schedule.dart';
import 'package:sample/view_vacancy.dart';

import 'attendexam.dart';
import 'change password.dart';
import 'home.dart';
import 'login.dart';
import 'mock.dart';

class Drawerclass extends StatelessWidget {
  const Drawerclass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text(
              "My App",
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text("Home"),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.green),
            title: const Text("View Profile"),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.work, color: Colors.orange),
            title: const Text("View Job Vacancy"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewVacancyPage(title: '',)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.send, color: Colors.purple),
            title: const Text("Vacancies Sent"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewVacancyRequest(title: "title")));
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule, color: Colors.cyan),
            title: const Text("View  Schedules"),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSchedule(title: '',)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_call, color: Colors.teal),
            title: const Text("Attend Interview"),

            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MockInterviewScreen()));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.check_circle, color: Colors.deepPurple),
          //   title: const Text("View Results"),
          //   onTap: () {
          //     // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewResultsScreen()));
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.report_problem, color: Colors.redAccent),
            title: const Text("Send Complaints & View Reply"),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => AppComplaint()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.indigo),
            title: const Text("Change Password"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyUserChangePassword()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page, color: Colors.black),
            title: const Text("view application status"),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  ViewVacancyRequest(title: '',)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const login()));
            },
          ),
        ],
      ),
    );
  }
}

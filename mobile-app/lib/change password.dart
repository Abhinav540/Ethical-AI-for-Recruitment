import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'login.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Change Password',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyUserChangePassword(),
    );
  }
}

class MyUserChangePassword extends StatefulWidget {
  @override
  State<MyUserChangePassword> createState() => _MyUserChangePasswordState();
}

class _MyUserChangePasswordState extends State<MyUserChangePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => home()));
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.green),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                'Change Password',

              ),
              const SizedBox(width: 40), // Placeholder for spacing
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(height: 150),
                const SizedBox(height: 60),
                _buildTextField(oldPasswordController, "Old Password", Icons.password),
                const SizedBox(height: 10),
                _buildTextField(newPasswordController, "New Password", Icons.password),
                const SizedBox(height: 10),
                _buildTextField(confirmPasswordController, "Confirm Password", Icons.password),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submit();
                    }
                  },
                  child: const Text("Change"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $label.";
        }
        if (label == "New Password" && value.length < 8) {
          return "Please enter New Password (minimum 8 characters).";
        }
        if (label == "Confirm Password" && value != newPasswordController.text) {
          return "Passwords do not match.";
        }
        return null;
      },
    );
  }

  void _submit() async {
    String oldPassword = oldPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String url = sharedPreferences.getString('url') ?? '';
    print(url);
    String lid = sharedPreferences.getString('lid') ?? '';
    final uri = Uri.parse('$url/and_change_password_post');
    print(uri);

    try {
      final response = await http.post(uri, body: {
        'old': oldPassword,
        'new': newPassword,
        'confirm': confirmPassword,
        'lid': lid,
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String status = responseData['status'];
        String message = responseData['message'] ?? '';

        if (status == 'ok') {
          Fluttertoast.showToast(msg: 'Password Updated Successfully');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => login()));
        } else {
          Fluttertoast.showToast(msg: 'Error: $message');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController previousCompanyController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? _image;
  File? _resume;
  final picker = ImagePicker();

  /// Request permissions before selecting an image
  // Future<void> _pickImage() async {
  //   var status = await Permission.photos.request(); // Request gallery permission
  //
  //   if (status.isDenied) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Gallery access denied. Please enable in settings.")),
  //     );
  //     return;
  //   }
  //
  //   if (status.isPermanentlyDenied) {
  //     openAppSettings(); // Open settings if denied permanently
  //     return;
  //   }
  //
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  Future<void> _pickImage() async {
    var status = await Permission.photos.request(); // For gallery access (iOS & Android 13+)
    var storageStatus = await Permission.storage.request(); // For older Android versions

    // if (status.isDenied || storageStatus.isDenied) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Gallery access denied. Please enable in settings.")),
    //   );
    //   return;
    // }

    // if (status.isPermanentlyDenied || storageStatus.isPermanentlyDenied) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text("Gallery access permanently denied. Open settings to enable."),
    //       action: SnackBarAction(
    //         label: "Open Settings",
    //         onPressed: () {
    //           openAppSettings(); // Opens system settings
    //         },
    //       ),
    //     ),
    //   );
    //   return;
    // }

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }


  /// Request permissions and pick a resume file
  Future<void> _pickResume() async {
    // var status = await Permission.storage.request(); // Request storage permission
    //
    // if (status.isDenied) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Storage access denied. Please enable in settings.")),
    //   );
    //   return;
    // }
    //
    // if (status.isPermanentlyDenied) {
    //   openAppSettings();
    //   return;
    // }


    var status = await Permission.manageExternalStorage.status;

    if (status.isGranted) {
      // Permission is already granted
      print("Manage external storage permission granted.");
    } else {
      // Request the permission
      var result = await Permission.manageExternalStorage.request();

      if (result.isGranted) {
        print("Permission granted after request.");
      } else {
        // If permission is denied (or permanently denied) direct the user to the settings
        print("Permission denied. Opening app settings...");
        await openAppSettings();
      }
    }





    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _resume = File(result.files.single.path!);
      });
    }
  }

  /// Register user and upload data to the backend
  Future<void> registerUser() async {
    if (_image == null || _resume == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a profile image and resume")),
      );
      return;
    }

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString("url");

    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server URL is missing in SharedPreferences")),
      );
      return;
    }

    var uri = Uri.parse(url+"registrationcode"); // Fixed URL formatting
    var request = http.MultipartRequest("POST", uri);

    request.fields["name"] = nameController.text;
    request.fields["place"] = placeController.text;
    request.fields["phone"] = phoneController.text;
    request.fields["qualification"] = qualificationController.text;
    request.fields["email"] = emailController.text;
    request.fields["experience"] = experienceController.text;
    request.fields["previouscompany"] = previousCompanyController.text;
    request.fields["uname"] = usernameController.text;
    request.fields["password"] = passwordController.text;

    request.files.add(await http.MultipartFile.fromPath("image", _image!.path));
    request.files.add(await http.MultipartFile.fromPath("resume", _resume!.path));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);

        if (jsonResponse["task"] == "valid") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration Successful!")),

          );
          Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
        }else if (jsonResponse["task"] == "exist") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Username already Exist...Please try again.....")),

          );
          Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration Failed! Try again.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
              TextField(controller: placeController, decoration: InputDecoration(labelText: "Place")),
              TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone Number")),
              TextField(controller: qualificationController, decoration: InputDecoration(labelText: "Qualification")),
              TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
              TextField(controller: experienceController, decoration: InputDecoration(labelText: "Experience")),
              TextField(controller: previousCompanyController, decoration: InputDecoration(labelText: "Previous Company")),
              TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text("Pick Image"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickResume,
                    child: Text("Pick Resume"),
                  ),
                ],
              ),

              _image != null ? Text("Image Selected") : Text("No Image Selected"),
              _resume != null ? Text("Resume Selected") : Text("No Resume Selected"),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerUser,
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




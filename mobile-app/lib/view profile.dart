import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String name = "Not Available";
  String place = "Not Available";
  String email = "Not Available";
  String phoneNumber = "No Phone Available";
  String experience = "No Experience Provided";
  String? imageUrl;
  String? resumeUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  /// Fetch user profile data from the server
  Future<void> fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String baseUrl = prefs.getString("url") ?? "";
      String lid = prefs.getString("lid") ?? "";

      if (baseUrl.isEmpty || lid.isEmpty) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Missing URL or User ID.")),
        );
        return;
      }

      final response = await http.post(
        Uri.parse(baseUrl+"user_view_profile"), // API Endpoint
        body: {"lid": lid},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["status"] == "ok") {
          setState(() {
            name = jsonData["name"] ?? "Not Available";
            place = jsonData["place"] ?? "Not Available";
            email = jsonData["email"] ?? "Not Available";
            phoneNumber = jsonData["phonenumber"] ?? "No Phone Available";
            experience = jsonData["Experiencedetails"] ?? "No Experience Provided";

            // Ensure full image URL
            imageUrl = prefs.getString("imgurl").toString()+jsonData["image"] != null && jsonData["image"].isNotEmpty
                ? prefs.getString("imgurl").toString()+jsonData["image"] // API should return full URL
                : null;

            // Ensure full resume URL
            resumeUrl = prefs.getString("imgurl").toString()+jsonData["resume"] != null && jsonData["resume"].isNotEmpty
                ? prefs.getString("imgurl").toString()+jsonData["resume"]
                : null;

            isLoading = false;
          });
          print(imageUrl);
        } else {
          throw Exception("Failed to load profile data.");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: imageUrl != null
                  ? ClipOval(
                child: Image.network(
                  imageUrl!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: 50);
                  },
                ),
              )
                  : CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            SizedBox(height: 20),
            buildInfoRow("Name", name),
            buildInfoRow("Place", place),
            buildInfoRow("Email", email),
            buildInfoRow("Phone Number", phoneNumber),
            buildInfoRow("Experience", experience),
            SizedBox(height: 10),
            if (resumeUrl != null)
              Center(
                child: ElevatedButton(
                  onPressed: () async {

                    final Uri url = Uri.parse(resumeUrl.toString());

                    await launchUrl(url);


                  },
                  child: Text("View Resume"),
                ),
              ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: fetchUserProfile,
                child: Text("Refresh"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to create labeled rows
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class UserProfileScreen extends StatefulWidget {
//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   String name = "Not Available";
//   String place = "Not Available";
//   String email = "Not Available";
//   String phoneNumber = "No Phone Available";
//   String experience = "No Experience Provided";
//   String? imageUrl;
//   String? resumeUrl;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserProfile();
//   }
//
//   /// Fetch user profile data from the server
//   Future<void> fetchUserProfile() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       String url = prefs.getString("url") ?? "";
//       String lid = prefs.getString("lid") ?? "";
//       String imgurl = prefs.getString("imgurl") ?? "";
//
//       if (url.isEmpty || lid.isEmpty) {
//         setState(() {
//           isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Missing URL or user ID.")),
//         );
//         return;
//       }
//
//       final response = await http.post(
//         Uri.parse(url+"user_view_profile"), // Ensure correct API endpoint
//         body: {"lid": lid},
//       );
//
//       if (response.statusCode == 200) {
//         var jsonData = jsonDecode(response.body);
//
//         if (jsonData["status"] == "ok") {
//           setState(() {
//             name = jsonData["name"] ?? "Not Available";
//             place = jsonData["place"] ?? "Not Available";
//             email = jsonData["email"] ?? "Not Available";
//             phoneNumber = jsonData["phonenumber"] ?? "No Phone Available"; // Ensure correct key
//             experience = jsonData["Experiencedetails"] ?? "No Experience Provided";
//
//             // Ensure full image URL
//             imageUrl = jsonData["image"] != null && jsonData["image"].isNotEmpty
//                 ? "$url${jsonData["image"]}"
//                 : null;
//
//             // Ensure full resume URL
//             resumeUrl = jsonData["resume"] != null && jsonData["resume"].isNotEmpty
//                 ? "$url${jsonData["resume"]}"
//                 : null;
//
//             isLoading = false;
//           });
//         } else {
//           throw Exception("Failed to load profile data.");
//         }
//       } else {
//         throw Exception("Server error: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("User Profile")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: imageUrl != null
//                   ? CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(imageUrl!),
//                 onBackgroundImageError: (_, __) => Icon(Icons.error),
//               )
//                   : CircleAvatar(
//                 radius: 50,
//                 child: Icon(Icons.person, size: 50),
//               ),
//             ),
//             SizedBox(height: 20),
//             buildInfoRow("Name", name),
//             buildInfoRow("Place", place),
//             buildInfoRow("Email", email),
//             buildInfoRow("Phone Number", phoneNumber),
//             buildInfoRow("Experience", experience),
//             SizedBox(height: 10),
//             if (resumeUrl != null)
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Opening Resume...")),
//                     );
//                   },
//                   child: Text("View Resume"),
//                 ),
//               ),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: fetchUserProfile,
//                 child: Text("Refresh"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Helper method to create labeled rows
//   Widget buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           Text(value, style: TextStyle(fontSize: 16)),
//         ],
//       ),
//     );
//   }
// }

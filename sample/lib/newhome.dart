import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Subtitle
                  Text(
                    "Courses Today",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Vocabulary 1",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Lorem Ipsum is a dummy text",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 15),
                  // Illustration
                  Center(
                    child: Image.asset("assets/aa.jpg",
                        height: 150),
                  ),
                  SizedBox(height: 15),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.play_arrow),
                        label: Text("START STUDY"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.edit),
                        label: Text("START REVIEW"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            // Course List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  CourseTile(
                      icon: Icons.book, title: "Vocabulary II", subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed"),
                  CourseTile(
                      icon: Icons.menu_book, title: "Vocabulary III", subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed"),
                  CourseTile(
                      icon: Icons.work, title: "Job Search and Interview", subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed"),
                ],
              ),
            ),
            // Bottom Navigation
            BottomNavigationBar(
              currentIndex: 0,
              selectedItemColor: Colors.pinkAccent,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "HOME",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.work),
                  label: "WORKPLACE",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit),
                  label: "EXAM",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.score),
                  label: "SCORES",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Course List Tile Widget
class CourseTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  CourseTile({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pinkAccent.shade100,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
        trailing: Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }
}

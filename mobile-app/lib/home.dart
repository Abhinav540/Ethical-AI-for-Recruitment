// import 'package:flutter/material.dart';
//
//
//
// import 'drawer.dart';
//
//
// class home extends StatefulWidget {
//   const home({Key? key}) : super(key: key);
//
//   @override
//   State<home> createState() => homeState();
// }
//
//
// class homeState extends State<home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text("home"),
//         ),
//         drawer: const Drawerclass(),
//         body: SafeArea(
//             child:Container(decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/backg.png"),
//                   fit: BoxFit.cover,)
//             ),))
//     );
//   }
// }
//
import 'package:flutter/material.dart';

import 'drawer.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("home", style: TextStyle(color: Colors.white, fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: const Drawerclass(),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // 📌 Profile Avatar
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/profile.png"), // Replace with actual image
                backgroundColor: Colors.white,
              ),

              const SizedBox(height: 20),

              // 📌 Welcome Text
              Text(
                "Welcome to home Page!",

              ),

              const SizedBox(height: 30),

              // 📌 Buttons Section
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    buildhomeCard(Icons.work, "Jobs"),
                    buildhomeCard(Icons.chat, "Messages"),
                    buildhomeCard(Icons.settings, "Settings"),
                    buildhomeCard(Icons.person, "Profile"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📌 Card Widget Function
  Widget buildhomeCard(IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title Clicked!")));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        color: Colors.white.withOpacity(0.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tpi_app/screens/cross/login.dart';
import 'package:tpi_app/screens/message/message.dart';
import 'package:tpi_app/screens/post/create_post.dart';
import 'package:tpi_app/screens/post/home_screen.dart';
import 'package:tpi_app/screens/student/collectdata.dart';
import 'package:tpi_app/screens/teacher/teachers_data_collector.dart';
import 'package:tpi_app/screens/cross/upload_profile.dart';
import 'package:tpi_app/screens/verification/verifivation_request.dart';

String name = '';
String deperment = '';
String shift = '';
String url = 'null';
String tag = '';

Widget img = const Center(
  child: Icon(
    Icons.person,
    size: 40,
  ),
);

class TeachersHome extends StatefulWidget {
  final name;
  final shift;
  final deperment;
  final tag;
  const TeachersHome(
      {super.key,
      required this.name,
      required this.deperment,
      required this.shift,
      required this.tag});

  @override
  State<TeachersHome> createState() => _TeachersHomeState();
}

class _TeachersHomeState extends State<TeachersHome> {
  int currentPage = 0;
  final style = const TextStyle(
    fontSize: 18,
  );

  @override
  Widget build(BuildContext context) {
    if (url == 'null') {
      try {
        Future(
          () async {
            String email = FirebaseAuth.instance.currentUser!.email.toString();
            final doc = await FirebaseFirestore.instance
                .collection('img')
                .doc(email)
                .get();
            if (doc.exists) {
              setState(() {
                url = doc['links'].toString();
                img = Image.network(
                  url,
                  fit: BoxFit.cover,
                );
              });
            }
          },
        );
      } catch (e) {}
    }
    setState(() {
      name = widget.name;
      deperment = widget.deperment;
      shift = widget.shift;
    });

    List body = <Widget>[
      const PostHome(),
      Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('img/back.jpg'), fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 36),
                ),
                const Divider(
                  color: Colors.blueGrey,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Deperment :',
                          style: style,
                        ),
                        Text(
                          deperment,
                          style: style,
                        )
                      ],
                    ),
                    const Divider(
                      color: Colors.blueGrey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Shift :',
                          style: style,
                        ),
                        Text(
                          shift,
                          style: style,
                        )
                      ],
                    ),
                    const Divider(
                      color: Colors.blueGrey,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        // ignore: use_build_context_synchronously
                        await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogIn(),
                            ),
                            (route) => false);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Log Out',
                            style: TextStyle(fontSize: 22),
                          ),
                          Icon(Icons.logout)
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.message),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Message(name: widget.name, tag: widget.tag, url: url),
              ),
            );
          }),
      appBar: AppBar(
        title: currentPage != 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Collector(),
                        ),
                      );
                    },
                    child: const Text(
                      'Update Profile',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(200, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePost(
                              name: widget.name, tag: widget.tag, url: url),
                        ),
                      );
                    },
                    child: const Text(
                      'Create A Post',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: body[currentPage],
      drawer: const NavigatorDrawerTeacher(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (int value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class NavigatorDrawerTeacher extends StatefulWidget {
  const NavigatorDrawerTeacher({super.key});

  @override
  State<NavigatorDrawerTeacher> createState() => _NavigatorDrawerTeacherState();
}

class _NavigatorDrawerTeacherState extends State<NavigatorDrawerTeacher> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.blue,
              child: img,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadPhoto(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.update),
                        Text(
                          "Update Photo",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TeacherDataCollector(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.update),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Update Profile info",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.verified),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Verify Yourself",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VerificationRequest(),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.notifications),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Verification Request",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.security),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Security",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.info),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "About",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

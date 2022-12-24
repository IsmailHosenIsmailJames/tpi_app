// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tpi_app/screens/student/home.dart';
import 'package:tpi_app/screens/teacher/teacher_home.dart';

class LoadingHomePage extends StatefulWidget {
  const LoadingHomePage({super.key});

  @override
  State<LoadingHomePage> createState() => _LoadingHomePageState();
}

class _LoadingHomePageState extends State<LoadingHomePage> {
  Future read() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    final doc = FirebaseFirestore.instance.collection('users').doc(email);
    final user = await doc.get();
    try {
      'Teacher'.contains(user['tag'].toString())
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => TeachersHome(
                  tag: user['tag'],
                  deperment: user['deperment'],
                  name: user['name'],
                  shift: user['shift'],
                ),
              ),
              (route) => false)
          : Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                    tag: user['tag'],
                    name: user['name'],
                    gender: user['gender'],
                    father: user['father'],
                    mother: user['mother'],
                    deperment: user["deperment"],
                    shift: user['shift'],
                    semester: user['semester'],
                    group: user['group'],
                    personalNumber: user['personal_mobile'],
                    parentsNumber: user['parents_mobile'],
                    address: user['address'],
                    reg: user['reg'],
                    roll: user['roll']),
              ),
              (route) => false);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    read();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('img/back.jpg'), fit: BoxFit.cover),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            Text(
              "Loading All required Data. Please Wait...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            )
          ],
        )),
      ),
    );
  }
}

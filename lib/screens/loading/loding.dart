// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tpi_app/screens/student/collectdata.dart';
import 'package:tpi_app/screens/loading/home_loding_page.dart';

class Lodding extends StatefulWidget {
  const Lodding({super.key});

  @override
  State<Lodding> createState() => _LoddingState();
}

class _LoddingState extends State<Lodding> {
  String error = "Loading...";
  Future readUser() async {
    try {
      Future(
        () async {
          final user = FirebaseAuth.instance.currentUser!;
          final docs = FirebaseFirestore.instance
              .collection('users')
              .doc('${user.email}');
          final snapshot = await docs.get();
          if (snapshot.exists) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoadingHomePage(),
                ),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Collector(),
                ),
                (route) => false);
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    readUser();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('img/back.jpg'), fit: BoxFit.cover),
        ),
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Text(
                error,
                style: const TextStyle(fontSize: 22, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

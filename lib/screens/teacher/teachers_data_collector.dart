import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../loading/home_loding_page.dart';

class TeacherDataCollector extends StatefulWidget {
  const TeacherDataCollector({super.key});

  @override
  State<TeacherDataCollector> createState() => _TeacherDataCollectorState();
}

class _TeacherDataCollectorState extends State<TeacherDataCollector> {
  final _key = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final shiftController = TextEditingController();
  final depermentController = TextEditingController();
  String errormassage = '';
  bool isLoding = false;

  List<String> depermrnt = [
    "computer",
    "civil",
    "electrical",
    "electronic",
    "mechanical",
    "construction"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        title: const Text('Teacher\'s Data'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('img/back.jpg'), fit: BoxFit.cover),
        ),
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (nameValidator(value!) == false) {
                        return "Enter a valid name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your Name',
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: shiftController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if ("12".contains(value!.toString()) &&
                          value.isNotEmpty) {
                        return null;
                      }
                      return "Enter Valid Registation Number";
                    },
                    decoration: InputDecoration(
                      hintText: 'What shift you are in?',
                      labelText: 'Shift',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: depermentController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (depermrnt.contains(value!.trim().toLowerCase()) &&
                          value.isNotEmpty) {
                        return null;
                      }
                      return "Computer, civil, electrica, electronic, mechanical, construction is avilable";
                    },
                    decoration: InputDecoration(
                      hintText: 'What is your Deperment?',
                      labelText: 'Deperment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    errormassage,
                    style: const TextStyle(fontSize: 14, color: Colors.red),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        setState(() {
                          isLoding = true;
                        });
                        final json = {
                          "tag": "Teacher",
                          "name": nameController.text.toString(),
                          "deperment": depermentController.text.toString(),
                          "shift": shiftController.text.toString(),
                        };
                        try {
                          Future(
                            () async {
                              final user = FirebaseAuth.instance.currentUser!;
                              final docUser = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc('${user.email}');
                              try {
                                await docUser.set(json);
                              } catch (e) {
                                await docUser.update(json);
                              }
                            },
                          );
                          setState(() {
                            isLoding = false;
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoadingHomePage(),
                              ),
                              (route) => false);
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            isLoding = false;
                            errormassage = e.message!;
                          });
                        }
                      } else {
                        setState(() {
                          errormassage = "Cheak if all info Given";
                          isLoding = false;
                        });
                      }
                    },
                    child: isLoding
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Submit',
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool nameValidator(String name) {
    if (name.isEmpty) return false;

    for (int i = 0; i < name.length; i++) {
      if ("1234567890!@#\$%^&*()~\"'/\\+_-=".contains(name[i])) {
        return false;
      }
    }
    return true;
  }
}

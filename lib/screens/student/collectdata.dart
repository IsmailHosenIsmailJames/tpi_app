import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tpi_app/screens/loading/home_loding_page.dart';
import 'package:tpi_app/screens/teacher/teachers_data_collector.dart';

class Collector extends StatefulWidget {
  const Collector({super.key});

  @override
  State<Collector> createState() => _CollectorState();
}

class _CollectorState extends State<Collector> {
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final fatherController = TextEditingController();
  final motherController = TextEditingController();
  final adressController = TextEditingController();
  final rollController = TextEditingController();
  final registationController = TextEditingController();
  final depermentController = TextEditingController();
  final semesterController = TextEditingController();
  final shiftController = TextEditingController();
  final groupController = TextEditingController();
  final personalMobileController = TextEditingController();
  final parentsMobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errormassage = '';
  bool isLoding = false;
  List<String> semester = ['1', '2', '3', '4', '5', '6', '7', '8'];
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
        title: const Center(child: Text('Give Us Your Data')),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Are you a Teacher?',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
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
                      child: const Text(
                        "I am a Teacher",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                      controller: genderController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (!["male", "female"]
                            .contains(value!.trim().toLowerCase())) {
                          return "Male or Female";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Male of Female',
                        labelText: 'Gender',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: fatherController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (nameValidator(value!) == false) {
                          return "Enter a valid name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your Father Name',
                        labelText: 'Father name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: motherController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (nameValidator(value!) == false) {
                          return "Enter a valid name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your Mother Name',
                        labelText: 'Mother name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: rollController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        try {
                          int.parse(value!);
                        } catch (e) {
                          return "Enter Valid Roll Number";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your Roll Number',
                        labelText: 'Roll Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: registationController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        try {
                          int.parse(value!);
                        } catch (e) {
                          return "Enter Valid Registation Number";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your Registation Number',
                        labelText: 'Registation Number',
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
                    TextFormField(
                      controller: semesterController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (semester.contains(value!.trim().toString())) {
                          return null;
                        }
                        return "Semester must be between 1 to 8";
                      },
                      decoration: InputDecoration(
                        hintText: 'What semester you are in?',
                        labelText: 'Semester',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: groupController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if ("AB".contains(value!.toUpperCase()) &&
                            value.isNotEmpty) {
                          return null;
                        }
                        return "Group is Not Valid";
                      },
                      decoration: InputDecoration(
                        hintText: 'Group',
                        labelText: 'What is your Group?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: personalMobileController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        try {
                          int.parse(value!);
                          if (value.length != 11) {
                            return "Number Not Valid";
                          }
                          if (value.substring(0, 2) != "01") {
                            return "Number Not Valid";
                          }
                        } catch (e) {
                          return "Number Not Valid";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your Mobile Number',
                        labelText: 'Your Mobile',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: parentsMobileController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        try {
                          int.parse(value!);
                          if (value.length != 11) {
                            return "Number Not Valid";
                          }
                          if (value.substring(0, 2) != "01") {
                            return "Number Not Valid";
                          }
                        } catch (e) {
                          return "Number Not Valid";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'What is your Parents Mobile Number',
                        labelText: 'Parents Mobile Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: adressController,
                      decoration: InputDecoration(
                        hintText: 'Enter your Address',
                        labelText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Text(
                      errormassage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoding = true;
                          });
                          final json = {
                            "tag": "Student",
                            "name": nameController.text.toString(),
                            "gender": genderController.text.toString(),
                            "father": fatherController.text.toString(),
                            "mother": motherController.text.toString(),
                            "deperment": depermentController.text.toString(),
                            "semester": semesterController.text.toString(),
                            "shift": shiftController.text.toString(),
                            "group": groupController.text.toString(),
                            "roll": rollController.text.toString(),
                            "reg": registationController.text.toString(),
                            "personal_mobile":
                                personalMobileController.text.toString(),
                            "parents_mobile":
                                parentsMobileController.text.toString(),
                            "address": adressController.text.toString(),
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
                                final allUsers = FirebaseFirestore.instance
                                    .collection('all_users')
                                    .doc('email');
                                final setEmails = await allUsers.get();
                                List listEmail = setEmails['emails'];
                                if (!listEmail.contains(user.email)) {
                                  listEmail.add(user.email);
                                  allUsers.update({'emails': listEmail});
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

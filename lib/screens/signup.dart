import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tpi_app/screens/collectdata.dart';
import 'package:tpi_app/screens/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailControler = TextEditingController();
  final passwordControler = TextEditingController();
  final confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errormassage = '';
  bool lodding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextFormField(
                          controller: emailControler,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (!EmailValidator.validate(value!.trim())) {
                              return "Enter a valid Email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your Email',
                            labelText: 'Email',
                            icon: const Icon(
                              Icons.email,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value!.length >= 4 ? null : "Password is short",
                          controller: passwordControler,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            labelText: 'password',
                            icon: const Icon(
                              Icons.password,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: confirmPassword,
                          validator: (value) => (confirmPassword.text.trim() ==
                                  passwordControler.text.trim())
                              ? null
                              : "Password didn't massed",
                          decoration: InputDecoration(
                            hintText: 'Enter your password agin',
                            labelText: 'Confirm password',
                            icon: const Icon(
                              Icons.password,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              signInWithGoogle();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Collector(),
                                  ),
                                  (route) => false);
                            } catch (e) {
                              setState(() {
                                errormassage = e.toString();
                              });
                            }
                          },
                          icon: SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset('img/google.jpg'),
                          ),
                          label: const Text(
                            'Sign Up with Google',
                            style: TextStyle(fontSize: 18, color: Colors.black),
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                lodding = true;
                              });
                              Future(
                                () async {
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: emailControler.text.trim(),
                                      password: passwordControler.text.trim(),
                                    );
                                    String email = FirebaseAuth
                                        .instance.currentUser!.email
                                        .toString();
                                    final allUsers = FirebaseFirestore.instance
                                        .collection('all_users')
                                        .doc('email');
                                    final setEmails = await allUsers.get();
                                    List listEmail = setEmails['emails'];
                                    listEmail.add(email);
                                    allUsers.update({'emails': listEmail});

                                    setState(() {
                                      lodding = false;
                                      errormassage = '';
                                    });
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Collector(),
                                        ),
                                        (route) => false);
                                  } on FirebaseException catch (e) {
                                    setState(() {
                                      lodding = false;
                                    });
                                    bool isConnected =
                                        await InternetConnectionChecker()
                                            .hasConnection;
                                    String error = isConnected
                                        ? "Something is worng, "
                                        : "You are Ofline";
                                    setState(() {
                                      errormassage = '$error\n${e.message}';
                                    });
                                  }
                                },
                              );
                            } else {
                              setState(() {
                                errormassage = "Cheak email and password";
                              });
                            }
                          },
                          child: lodding
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(fontSize: 22),
                                ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already Haven an account! ",
                        style: TextStyle(fontSize: 14),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(60, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogIn(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

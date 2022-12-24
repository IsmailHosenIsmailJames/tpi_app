import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestVerify extends StatefulWidget {
  const RequestVerify({super.key});

  @override
  State<RequestVerify> createState() => _RequestVerifyState();
}

class _RequestVerifyState extends State<RequestVerify> {
  String massage = '';
  bool isAlreadyverifified = false, loadding = false;
  @override
  Widget build(BuildContext context) {
    Future(
      () async {
        String email = FirebaseAuth.instance.currentUser!.email.toString();
        final vefified = FirebaseFirestore.instance
            .collection('verification')
            .doc('verified');
        final verified = await vefified.get();
        List verifiedList = verified['verified'];
        if (verifiedList.contains(email)) {
          setState(() {
            isAlreadyverifified = true;
          });
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.greenAccent[100],
      appBar: AppBar(title: const Text('Verification')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isAlreadyverifified
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      textAlign: TextAlign.center,
                      'You are allready Verified',
                      style: TextStyle(fontSize: 22),
                    ),
                    Icon(
                      Icons.verified,
                      color: Colors.green,
                      size: 100,
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Verify means Teachers will judge your all information that you have been given. If your info are ok, then teacher will mark your account as an verified account',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      massage,
                      style: const TextStyle(fontSize: 20, color: Colors.red),
                    ),
                    ElevatedButton(
                      child: loadding
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Request for Verification'),
                      onPressed: () {
                        setState(() {
                          loadding = true;
                        });
                        Future(
                          () async {
                            String email = FirebaseAuth
                                .instance.currentUser!.email
                                .toString();
                            final rquest = FirebaseFirestore.instance
                                .collection('verification')
                                .doc('request');

                            final docs = await rquest.get();

                            List listrequest = docs['request'];
                            if (!listrequest.contains(email)) {
                              listrequest.add(email);
                              rquest.update({'request': listrequest});
                              setState(() {
                                massage = "Request has sent, You can go back.";
                              });
                            } else {
                              setState(() {
                                massage =
                                    "You was sent request earlier.\nYou can't request agin";
                              });
                            }
                          },
                        );
                        setState(() {
                          loadding = false;
                        });
                      },
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

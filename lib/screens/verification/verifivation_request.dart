import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tpi_app/screens/verification/details_of_requseted_student.dart';

class VerificationRequest extends StatefulWidget {
  const VerificationRequest({super.key});

  @override
  State<VerificationRequest> createState() => _VerificationRequestState();
}

class _VerificationRequestState extends State<VerificationRequest> {
  List<Widget> allRequest = [const CircularProgressIndicator()];
  bool oneTimeCall = false;
  Future buildRequest() async {
    final fileLocation =
        FirebaseFirestore.instance.collection('verification').doc('request');
    try {
      final doc = await fileLocation.get();
      if (doc.exists) {
        List emails = doc['request'];
        if (emails.isEmpty) {
          setState(() {
            allRequest = [const Text('There is No Request')];
          });
        } else {
          allRequest = [];
          for (int i = emails.length - 1; i >= 0; i++) {
            String userEmail = emails[i];
            final prfilePhotoLocation = await FirebaseFirestore.instance
                .collection('img')
                .doc(userEmail)
                .get();
            Widget img = const Icon(
              Icons.person,
              size: 30,
            );
            if (prfilePhotoLocation.exists) {
              String imgUrl = prfilePhotoLocation['links'];
              setState(
                () {
                  img = img = ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: imgUrl,
                      key: UniqueKey(),
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  );
                },
              );
            }
            setState(() {
              allRequest.add(
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RequstDetails(email: userEmail),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 55, width: 55, child: img),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              userEmail.length > 32
                                  ? '${userEmail.substring(0, 30)}...'
                                  : userEmail,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            });
          }
        }
      }
    } catch (e) {
      setState(() {
        allRequest = [
          ElevatedButton(
            onPressed: () {
              buildRequest();
            },
            child: const Text(
              'Try agin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (oneTimeCall == false) {
      buildRequest();
      oneTimeCall = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Request'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: allRequest,
            ),
          ),
        ),
      ),
    );
  }
}

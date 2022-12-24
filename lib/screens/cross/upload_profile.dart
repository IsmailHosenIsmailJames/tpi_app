import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({super.key});

  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  String error = "";
  File? pickedFile;
  Future<void> pickIamge() async {
    final result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 5,
    );
    if (result == null) return;
    setState(() {
      pickedFile = File(result.path);
    });
  }

  Future uploadImage() async {
    setState(() {
      error = 'Uploading...';
    });
    try {
      final path =
          'images/${FirebaseAuth.instance.currentUser!.email.toString().split('@')[0]}.jpg';
      if (pickedFile == null) {
        setState(() {
          error == "No Image Selected";
        });
        return;
      }
      final file = File(pickedFile!.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadtask = ref.putFile(file);
      final snapshot = await uploadtask.whenComplete(() => null);
      final urlDonwload = await snapshot.ref.getDownloadURL();
      setState(() {
        error = 'Successfully uploaded';
      });
      String email = FirebaseAuth.instance.currentUser!.email.toString();
      final doc = FirebaseFirestore.instance.collection('img').doc(email);
      try {
        doc.set({'links': urlDonwload.toString()});
      } catch (e) {
        doc.update({'links': urlDonwload.toString()});
      }
      setState(() {
        error = 'Done all task';
      });
    } on FirebaseException catch (e) {
      setState(() {
        error = e.message!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text('Choose your profile'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('img/back.jpg'), fit: BoxFit.cover),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.blue,
                  child: pickedFile != null
                      ? Image.file(
                          File(pickedFile!.path),
                          fit: BoxFit.cover,
                        )
                      : const Text(
                          'No image selected!',
                          textAlign: TextAlign.center,
                        ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    pickIamge();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.image,
                        size: 26,
                      ),
                      Text('Choose from Gallery'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    uploadImage();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.upload_file,
                        size: 26,
                      ),
                      Text('Upload image'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

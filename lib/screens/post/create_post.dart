import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tpi_app/screens/teacher/teacher_home.dart';

class CreatePost extends StatefulWidget {
  final String tag, name, url;
  const CreatePost(
      {super.key, required this.tag, required this.name, required this.url});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  List<File> pickedFile = [];
  Future<void> pickIamge() async {
    final result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 5,
    );
    if (result == null) return;
    setState(
      () {
        pickedFile.add(File(result.path));
        Widget temWidget = Padding(
          padding: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(pickedFile.last),
          ),
        );
        imgList.add(temWidget);
      },
    );
  }

  Widget curste = const Text(
    'Post',
    style: TextStyle(fontSize: 22),
  );

  Future uploadPost() async {
    setState(() {
      curste = const CircularProgressIndicator(
        color: Colors.white,
      );
    });
    try {
      DateTime now = DateTime.now();
      int year = now.year;
      int month = now.month;
      int day = now.day;
      int hour = now.hour;
      int minutes = now.minute;
      int sec = now.second;
      int milisec = now.millisecond;
      int id = year * 365 * 24 * 60 * 60 * 1000 +
          month * 30 * 24 * 60 * 60 * 1000 +
          day * 24 * 60 * 60 * 1000 +
          hour * 60 * 60 * 1000 +
          minutes * 60 * 1000 +
          sec * 1000 +
          milisec;
      id = widget.tag == 'Teacher' ? id + 3 * 24 * 60 * 60 * 1000 : id;
      List<String> imgpath = [];
      for (int i = 0; i < pickedFile.length; i++) {
        curste = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Text('Uploading Image No- $i')
          ],
        );
        final path = 'post/$id-$i.jpg';
        final file = File(pickedFile[i].path);
        final ref = FirebaseStorage.instance.ref().child(path);
        final uploadtask = ref.putFile(file);
        final snapshot = await uploadtask.whenComplete(() => null);
        final urlDonwload = await snapshot.ref.getDownloadURL();
        imgpath.add(urlDonwload.toString());
      }
      setState(() {
        curste = const Text('All image uploaded');
      });
      id = tag == "Teacher" ? id + 3 * 24 * 60 * 60 * 1000 : id;
      final json = {
        'tag': widget.tag,
        'img': imgpath,
        'profile': widget.url,
        'name': widget.name,
        'email': FirebaseAuth.instance.currentUser!.email,
        'message': controller.text.toString(),
        'time': "$day ${([
          "Jannuary",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December"
        ])[month - 1]} $year, ${([
          "Sun",
          "Mon",
          "Tue",
          "Wed",
          "Thu",
          "Fri",
          "Sat",
        ])[now.weekday - 1]},    $hour:$minutes:$sec",
      };

      final ref = FirebaseFirestore.instance.collection('post').doc('$id');
      ref.set(json);
      setState(() {
        curste = const Text(
          'Done',
          style: TextStyle(fontSize: 22),
        );
      });
    } on FirebaseException catch (e) {
      setState(() {
        curste = Text(
          e.message.toString(),
          style: const TextStyle(fontSize: 22),
        );
      });
    }
  }

  List<Widget> imgList = [
    const Text(
      'You Can select multipule Image\nAll Image will show here.',
      textAlign: TextAlign.center,
    )
  ];

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a post'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  textAlign: TextAlign.start,
                  enableSuggestions: true,
                  autocorrect: true,
                  controller: controller,
                  maxLines: 100,
                  minLines: 2,
                  decoration: InputDecoration(
                    suffix: IconButton(
                      onPressed: () {
                        controller.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    hintText: 'What\'s in your mind?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onPressed: () {
                        pickIamge();
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.image),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Select Image'),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: () {
                      uploadPost();
                    },
                    child: curste),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: imgList,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

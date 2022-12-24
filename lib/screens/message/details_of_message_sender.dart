import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tpi_app/screens/teacher/teacher_home.dart';

class DetailsOfMessageSender extends StatefulWidget {
  final String email;
  const DetailsOfMessageSender({
    super.key,
    required this.email,
  });

  @override
  State<DetailsOfMessageSender> createState() => _DetailsOfMessageSenderState();
}

Widget img = const Icon(
  Icons.person,
  size: 100,
);
String name = '';
String gender = '';
String father = '';
String mother = '';
String deperment = '';
String shift = '';
String semester = '';
String group = '';
String address = '';
String personalNumber = '';
String parentsNumber = '';
String roll = '';
String reg = '';

class _DetailsOfMessageSenderState extends State<DetailsOfMessageSender> {
  final style = const TextStyle(
    fontSize: 18,
  );
  bool success = false, loading = false;
  String massage = '';
  Future getData() async {
    try {
      final doc =
          FirebaseFirestore.instance.collection('users').doc(widget.email);
      final prfilePhotoLocation = await FirebaseFirestore.instance
          .collection('img')
          .doc(widget.email)
          .get();
      if (prfilePhotoLocation.exists) {
        String imgUrl = prfilePhotoLocation['links'];
        setState(() {
          img = ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              key: UniqueKey(),
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
        });
      }

      final user = await doc.get();
      if (user.exists) {
        setState(() {
          name = user['name'];
          gender = user['gender'];
          father = user['father'];
          mother = user['mother'];
          deperment = user["deperment"];
          shift = user['shift'];
          semester = user['semester'];
          group = user['group'];
          personalNumber = user['personal_mobile'];
          parentsNumber = user['parents_mobile'];
          address = user['address'];
          reg = user['reg'];
          roll = user['roll'];
          success = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (success == false) {
      getData();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Details'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green[100],
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(widget.email),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: img,
                ),
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
                    const Divider(
                      color: Colors.blueGrey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Gender :',
                          style: style,
                        ),
                        Text(
                          gender,
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
                          'Father\'s :',
                          style: style,
                        ),
                        Text(
                          father,
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
                          'mother\'s :',
                          style: style,
                        ),
                        Text(
                          mother,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'semester :',
                          style: style,
                        ),
                        Text(
                          semester,
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
                          'Group :',
                          style: style,
                        ),
                        Text(
                          group,
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
                          'Roll :',
                          style: style,
                        ),
                        Text(
                          roll,
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
                          'Registation :',
                          style: style,
                        ),
                        Text(
                          reg,
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
                          'Personal Phone :',
                          style: style,
                        ),
                        Text(
                          personalNumber,
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
                          'Parents Phone :',
                          style: style,
                        ),
                        Text(
                          parentsNumber,
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
                          'Adress :',
                          style: style,
                        ),
                        Text(
                          address,
                          style: style,
                        )
                      ],
                    ),
                    const Divider(
                      color: Colors.blueGrey,
                    ),
                    Text(
                      massage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

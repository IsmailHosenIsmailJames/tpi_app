// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tpi_app/screens/message/message.dart';
import 'package:tpi_app/screens/post/create_post.dart';
import 'package:tpi_app/screens/post/home_screen.dart';
import 'package:tpi_app/screens/student/collectdata.dart';
import 'package:tpi_app/screens/cross/login.dart';
import 'package:tpi_app/screens/developer/developer.dart';
import 'package:tpi_app/screens/verification/request_verify.dart';
import 'package:tpi_app/screens/cross/upload_profile.dart';

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
String url = 'null';
Widget img = const Center(
  child: Icon(
    Icons.person,
    size: 40,
  ),
);

class Home extends StatefulWidget {
  final name,
      father,
      mother,
      deperment,
      semester,
      shift,
      group,
      roll,
      personalNumber,
      parentsNumber,
      address,
      reg,
      gender,
      tag;
  const Home({
    super.key,
    required this.name,
    required this.gender,
    required this.father,
    required this.mother,
    required this.deperment,
    required this.shift,
    required this.semester,
    required this.reg,
    required this.roll,
    required this.group,
    required this.address,
    required this.personalNumber,
    required this.parentsNumber,
    required this.tag,
  });
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = TextEditingController();
  String verifiedmassage = '';
  bool verificationFunctionCalled = false,
      isAlreadyverifified = false,
      loadding = false,
      isMassageBuildCalled = false;
// cheak is verified

  Future cheakIsVerified() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    final vefified =
        FirebaseFirestore.instance.collection('verification').doc('verified');
    final verified = await vefified.get();
    List verifiedList = verified['verified'];
    if (verifiedList.contains(email)) {
      setState(() {
        isAlreadyverifified = true;
        verificationFunctionCalled = true;
      });
    } else {
      notVerified();
    }
  }

  Future buildMessage() async {
    setState(() {
      massage = [const Text('Verified')];
      isMassageBuildCalled = true;
    });
  }

  void notVerified() {
    setState(() {
      massage = [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RequestVerify(),
              ),
            );
          },
          child: const Text('Apply for Verification'),
        ),
      ];
    });
  }

  List<Widget> massage = [const CircularProgressIndicator()];
  int currentPage = 0;
  final style = const TextStyle(
    fontSize: 18,
  );
  @override
  Widget build(BuildContext context) {
    if (url == 'null') {
      try {
        Future(
          () async {
            String email = FirebaseAuth.instance.currentUser!.email.toString();
            final doc = await FirebaseFirestore.instance
                .collection('img')
                .doc(email)
                .get();
            if (doc.exists) {
              setState(
                () {
                  url = doc['links'];
                  img = ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(80),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      key: UniqueKey(),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  );
                },
              );
            }
          },
        );
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      name = widget.name;
      gender = widget.gender;
      father = widget.father;
      mother = widget.mother;
      deperment = widget.deperment;
      shift = widget.shift;
      semester = widget.semester;
      group = widget.group;
      address = widget.address;
      personalNumber = widget.personalNumber;
      parentsNumber = widget.parentsNumber;
      roll = widget.roll;
      reg = widget.reg;
    });
    List body = <Widget>[
      const PostHome(),
      Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('img/back.jpg'), fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        // ignore: use_build_context_synchronously
                        await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogIn(),
                            ),
                            (route) => false);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Log Out',
                            style: TextStyle(fontSize: 22),
                          ),
                          Icon(Icons.logout)
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    ];
    if (verificationFunctionCalled == false) {
      cheakIsVerified();
    }
    if (isAlreadyverifified == true) {
      if (isMassageBuildCalled == false) {
        buildMessage();
      }
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.message),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Message(name: widget.name, tag: widget.tag, url: url),
              ),
            );
          }),
      appBar: AppBar(
        title: currentPage != 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Collector(),
                        ),
                      );
                    },
                    child: const Text(
                      'Update Profile',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(200, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePost(
                              name: widget.name, tag: widget.tag, url: url),
                        ),
                      );
                    },
                    child: const Text(
                      'Create A Post',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: body[currentPage],
      drawer: const NavigationDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (int value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({super.key});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: img,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadPhoto(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.update),
                        Text(
                          "Update photo",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RequestVerify(),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.verified),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Verification",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.security),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Security",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Developer(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.info),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "About",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tpi_app/main.dart';
import 'package:tpi_app/screens/message/details_of_message_sender.dart';

class Message extends StatefulWidget {
  final String name;
  final String tag;
  final String url;
  const Message(
      {super.key, required this.name, required this.tag, required this.url});

  @override
  State<Message> createState() => _MessageState();
}

String paragraph(String text) {
  bool got = false;
  if (text.length < 32) return text;
  for (int i = 0; i < text.length; i++) {
    if (i % 30 == 0 && i != 0) {
      for (int x = 0; x < 10; x++) {
        if (text[i - x] == " ") {
          text = text.replaceRange((i - x), (i - x), '\n');
          got = true;
          break;
        }
      }
      if (got == false) {
        text = text.replaceRange(i, i, "-\n");
      }
      got = false;
    }
  }
  return text;
}

class _MessageState extends State<Message> {
  String userEmail = FirebaseAuth.instance.currentUser!.email.toString();
  final ref = FirebaseFirestore.instance.collection('chat');
  String id = '';
  final controller = TextEditingController();
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
        title: const Text('Message'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.message),
        onPressed: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            context: context,
            builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Type your message',
                    labelText: 'Message',
                    suffixIcon: IconButton(
                      onPressed: () => controller.clear(),
                      icon: const Icon(Icons.clear),
                    ),
                    icon: const Icon(Icons.message),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  controller: controller,
                  autocorrect: true,
                  minLines: 1,
                  maxLines: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
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
                    String messageToSend = controller.text.toString();
                    final ref = FirebaseFirestore.instance
                        .collection('chat')
                        .doc('$id');
                    final json = {
                      'tag': widget.tag,
                      'img': widget.url,
                      'name': widget.name,
                      'email': FirebaseAuth.instance.currentUser!.email,
                      'message': messageToSend,
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
                    try {
                      if (!(controller.text.toString() == '' ||
                          controller.text.toString() == " ")) {
                        controller.clear();
                        await ref.set(json);
                      }
                    } catch (e) {}
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.send),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Send message'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      body: Container(
        color: const Color.fromARGB(255, 204, 255, 252),
        child: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text('No Data'),
              );
            }
            int len = snapshot.data!.docs.length - 1;
            return ListView.builder(
              addAutomaticKeepAlives: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                String email =
                    snapshot.data!.docs[len - index].data()['email'].toString();
                return userEmail == email
                    ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              textAlign: TextAlign.end,
                              "@${widget.name} - ${widget.tag}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              snapshot.data!.docs[len - index].data()['time'],
                              style: const TextStyle(fontSize: 10),
                            ),
                            GestureDetector(
                              onLongPress: () => showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                context: context,
                                builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: snapshot
                                                .data!.docs[len - index]
                                                .data()['message']
                                                .toString(),
                                          ),
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: const [
                                          Icon(Icons.copy),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text('Copy the message'),
                                        ],
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        String id =
                                            snapshot.data!.docs[len - index].id;

                                        final ref = FirebaseFirestore.instance
                                            .collection('chat')
                                            .doc(id);
                                        ref.delete();
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: const [
                                          Icon(Icons.delete),
                                          SizedBox(width: 20),
                                          Text('Delete the message'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              child: Container(
                                width: (snapshot.data!.docs[len - index]
                                            .data()['message']
                                            .toString()
                                            .length >
                                        30
                                    ? 265
                                    : (snapshot.data!.docs[len - index]
                                                .data()['message']
                                                .toString()
                                                .length <
                                            15
                                        ? snapshot.data!.docs[len - index]
                                                .data()['message']
                                                .toString()
                                                .length *
                                            9
                                        : snapshot.data!.docs[len - index]
                                                    .data()['message']
                                                    .toString()
                                                    .length *
                                                7 +
                                            8)),
                                height: (snapshot.data!.docs[len - index]
                                            .data()['message']
                                            .toString()
                                            .length >
                                        32
                                    ? (snapshot.data!.docs[len - index]
                                                    .data()['message']
                                                    .toString()
                                                    .length /
                                                33) *
                                            20 +
                                        27
                                    : 40),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      snapshot.data!.docs[len - index]
                                          .data()['message']
                                          .toString(),
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (snapshot.data!.docs[len - index].data()['img'] ==
                                    'null')
                                ? GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailsOfMessageSender(
                                                email: email),
                                      ),
                                    ),
                                    child: const Icon(Icons.person),
                                  )
                                : GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailsOfMessageSender(
                                                email: email),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.docs[len - index]
                                            .data()['img'],
                                        key: UniqueKey(),
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '@${snapshot.data!.docs[len - index].data()['name']} - ${snapshot.data!.docs[len - index].data()['tag']}',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data!.docs[len - index]
                                      .data()['time'],
                                  style: const TextStyle(fontSize: 10),
                                ),
                                GestureDetector(
                                  onLongPress: () => showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            Clipboard.setData(
                                              ClipboardData(
                                                text: snapshot
                                                    .data!.docs[len - index]
                                                    .data()['message']
                                                    .toString(),
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: const [
                                              Icon(Icons.copy),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text('Copy the message'),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Container(
                                    width: (snapshot.data!.docs[len - index]
                                                .data()['message']
                                                .toString()
                                                .length >
                                            30
                                        ? 265
                                        : (snapshot.data!.docs[len - index]
                                                    .data()['message']
                                                    .toString()
                                                    .length <
                                                15
                                            ? snapshot.data!.docs[len - index]
                                                        .data()['message']
                                                        .toString()
                                                        .length *
                                                    10 +
                                                10
                                            : snapshot.data!.docs[len - index]
                                                        .data()['message']
                                                        .toString()
                                                        .length *
                                                    7 +
                                                8)),
                                    height: (snapshot.data!.docs[len - index]
                                                .data()['message']
                                                .toString()
                                                .length >
                                            32
                                        ? (snapshot.data!.docs[len - index]
                                                        .data()['message']
                                                        .toString()
                                                        .length /
                                                    33) *
                                                20 +
                                            27
                                        : 40),
                                    decoration: const BoxDecoration(
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(
                                          snapshot.data!.docs[len - index]
                                              .data()['message']
                                              .toString(),
                                          maxLines: 100,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
              },
            );
          },
        ),
      ),
    );
  }
}

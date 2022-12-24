import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tpi_app/screens/message/details_of_message_sender.dart';

class PostHome extends StatefulWidget {
  const PostHome({super.key});

  @override
  State<PostHome> createState() => _PostHomeState();
}

class _PostHomeState extends State<PostHome> {
  final ref = FirebaseFirestore.instance.collection('post');
  String email = FirebaseAuth.instance.currentUser!.email.toString();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 226, 255, 227),
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
            itemCount: snapshot.data!.docs.length,
            addAutomaticKeepAlives: true,
            itemBuilder: (context, index) {
              List<Widget> temImg = [];
              List imgLink = snapshot.data!.docs[len - index].data()['img'];
              for (int i = 0; i < imgLink.length; i++) {
                temImg.add(
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: imgLink[i],
                          key: UniqueKey(),
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              }
              String message =
                  snapshot.data!.docs[len - index].data()['message'];
              String postEmail =
                  snapshot.data!.docs[len - index].data()['email'];
              String tag = snapshot.data!.docs[len - index].data()['tag'];
              String name = snapshot.data!.docs[len - index].data()['name'];
              String time = snapshot.data!.docs[len - index].data()['time'];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsOfMessageSender(email: postEmail),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: snapshot.data!.docs[len - index]
                                          .data()['profile'] ==
                                      'null'
                                  ? const Icon(Icons.person)
                                  : CachedNetworkImage(
                                      imageUrl: snapshot.data!.docs[len - index]
                                          .data()['profile'],
                                      key: UniqueKey(),
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$name -   $tag',
                                  style: const TextStyle(
                                      backgroundColor: Colors.greenAccent,
                                      fontSize: 18),
                                ),
                                Text(
                                  time,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                                      text: snapshot.data!.docs[len - index]
                                          .data()['message']
                                          .toString(),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            maxLines: 150,
                            message,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                      Column(
                        children: temImg,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     OutlinedButton(
                      //       style: ElevatedButton.styleFrom(
                      //         minimumSize: const Size(150, 40),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(100),
                      //         ),
                      //       ),
                      //       onPressed: () {},
                      //       child: const Icon(
                      //         Icons.thumb_up,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //     OutlinedButton(
                      //       style: ElevatedButton.styleFrom(
                      //         minimumSize: const Size(150, 40),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(100),
                      //         ),
                      //       ),
                      //       onPressed: () {},
                      //       child: const Icon(
                      //         Icons.comment,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

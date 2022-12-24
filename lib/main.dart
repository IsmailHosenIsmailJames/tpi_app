import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tpi_app/screens/loading/loding.dart';
import 'package:tpi_app/screens/cross/login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TPI());
}

final navigatorKey = GlobalKey<NavigatorState>();

class TPI extends StatelessWidget {
  const TPI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LetsGo(),
    );
  }
}

class LetsGo extends StatefulWidget {
  const LetsGo({super.key});

  @override
  State<LetsGo> createState() => _LetsGoState();
}

class _LetsGoState extends State<LetsGo> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) =>
          snapshot.hasData ? const Lodding() : const LogIn(),
    );
  }
}

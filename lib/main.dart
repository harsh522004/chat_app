import 'package:chat_app/Screens/Auth/Chat_Screen.dart';
import 'package:chat_app/Screens/Auth/welcome.dart';
import 'package:chat_app/Utilities/text_theme.dart';
import 'package:chat_app/constant/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: HtextTheme.hTextTheme,
        primarySwatch: materialColor,
        useMaterial3: true,
      ),
      title: 'Flutter Demo',
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const ChatScreen();
            }
            return const WelcomeScreen();
          }),
    );
  }
}

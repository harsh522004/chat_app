import 'package:chat_app/Screens/Auth/Auth.dart';
import 'package:chat_app/constant/Colors.dart';
import 'package:chat_app/constant/Images.dart';
import 'package:flutter/material.dart';

import '../../Widgets/Elevated_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: materialColor[500], // You can change the color here
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              hWelcomeimage, // Replace with your image path
              height: 350,
              width: 350,
            ),
            const SizedBox(height: 20),
            Image.asset(
              hinstaImage,
              width: 300,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: HelevatedButton(
                text: 'Login',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen(
                              title: 'Welcome Back!',
                              subtitle: 'Login to your account',
                              buttonLabel: 'Login',
                              isLoginScreen: true)));
                },
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 300,
              height: 50,
              child: HelevatedButton(
                text: 'SignUp',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  const AuthScreen(
                              title: 'Welcome!',
                              subtitle: 'Register For Unlimited Chat!',
                              buttonLabel: 'SignUp',
                              isLoginScreen: false)));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

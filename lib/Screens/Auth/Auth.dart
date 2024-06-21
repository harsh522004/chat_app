import 'dart:io';
import 'package:chat_app/Screens/Auth/Chat_Screen.dart';
import 'package:chat_app/Screens/Auth/welcome.dart';
import 'package:chat_app/Widgets/Elevated_button.dart';
import 'package:chat_app/constant/Images.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Utilities/text_theme.dart';
import '../../Widgets/User_Profile_Image.dart';
import '../../constant/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final bool isLoginScreen;

  const AuthScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.isLoginScreen,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passController = TextEditingController();

  final _usernameController = TextEditingController();

  File? _selectedImage;

  bool _isAuthentication = false;

  // when button Clicked
  void _onSaved() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || (!widget.isLoginScreen && _selectedImage == null)) {
      return;
    }
    _form.currentState!.save();
    try {
      setState(() {
        _isAuthentication = true;
      });
      if (!widget.isLoginScreen) {
        final userCred = await _firebase.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passController.text);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('User_Images')
            .child('${userCred.user!.uid}.jpg');
        await storageRef.putFile(_selectedImage!);
        final userImageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('User')
            .doc(userCred.user!.uid)
            .set({
          'username': _usernameController.text,
          'email': _emailController.text,
          'imageUrl': userImageUrl,
        });

        _usernameController.clear();
        _emailController.clear();
        _passController.clear();



        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      } else {
        final userCred = await _firebase.signInWithEmailAndPassword(
            email: _emailController.text, password: _passController.text);
        _emailController.clear();
        _passController.clear();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));

        setState(() {
          _isAuthentication = false;
        });
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication Error')));
      setState(() {
        _isAuthentication = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = !widget.isLoginScreen
        ? Row(
            children: [
              UserProfileImage(
                onPickImage: (pickedImage) {
                  _selectedImage = pickedImage;
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    widget.title,
                    style: HtextTheme.hTextTheme.headlineLarge
                        ?.copyWith(fontSize: 40),
                  ),

                  // subtitle
                  Text(
                    widget.subtitle,
                    style: HtextTheme.hTextTheme.titleMedium,
                  ),
                ],
              ),
              // title
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style:
                    HtextTheme.hTextTheme.headlineLarge?.copyWith(fontSize: 40),
              ),

              // subtitle
              Text(
                widget.subtitle,
                style: HtextTheme.hTextTheme.titleMedium,
              ),
            ],
          );

    return Scaffold(
      backgroundColor: materialColor[500],
      body: SingleChildScrollView(
        child: Stack(
          children: [
            //Image
            Card(
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                    child: Image.asset(
                      widget.isLoginScreen ? hlogInImage : hSignupImage,
                      fit: BoxFit.cover,
                    )),
              ),
            ),

            //Icon Back
            Positioned(
              top: 37,
              left: 12,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            // content
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 200),

                    content,

                    const SizedBox(height: 30),

                    if (!widget.isLoginScreen)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              materialColor[50]!,
                              materialColor[400]!,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: TextFormField(
                          controller: _usernameController,
                          style: TextStyle(color: materialColor[700]),
                          decoration: InputDecoration(
                            hintText: 'Username',
                            prefixIcon: const Icon(Icons.face),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().length < 4 ||
                                value.isEmpty) {
                              return 'Please enter Valid UserName';
                            }
                            return null;
                          },
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Email Input
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            materialColor[50]!,
                            materialColor[400]!,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        style: TextStyle(color: materialColor[700]),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return 'Please Enter Your Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // password Input
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            materialColor[50]!,
                            materialColor[400]!,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: TextFormField(
                        controller: _passController,
                        style: TextStyle(color: materialColor[700]),
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().length < 6 ||
                              value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 250),
                    if (_isAuthentication)
                      Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(materialColor[800]),
                        ),
                      ),
                    if (!_isAuthentication)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: HelevatedButton(
                          text: widget.buttonLabel,
                          onTap: _onSaved,
                        ),
                      ),
                    const SizedBox(height: 10),

                    if (!_isAuthentication)
                      // Screen Change Text Button
                      Center(
                        child: TextButton(
                          onPressed: () {
                            if(widget.isLoginScreen){
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const  AuthScreen(title: 'Sign Up', subtitle: 'Create an account to get started', buttonLabel: 'Sign Up', isLoginScreen: false),),
                              );
                            } else{
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const AuthScreen(
                                    title: 'Log In',
                                    subtitle: 'Log in to your account',
                                    buttonLabel: 'Log In',
                                    isLoginScreen: true,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  style: TextStyle(color: materialColor[100]),
                                  text: widget.isLoginScreen
                                      ? "Don't have an account? "
                                      : "Already have an account? ",
                                ),
                                TextSpan(
                                  text: widget.isLoginScreen
                                      ? 'Sign Up'.toUpperCase()
                                      : 'LogIn',
                                  style: TextStyle(
                                    color: materialColor[100],
                                    decoration: TextDecoration.combine([
                                      TextDecoration.underline,
                                    ]),
                                    decorationColor:
                                        Colors.white, // Set underline color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

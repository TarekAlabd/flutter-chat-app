import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechatapp/screens/chat_screen.dart';
import 'package:firebasechatapp/screens/login_screen.dart';
import 'package:firebasechatapp/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        primarySwatch: Colors.pink,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SplashScreen();
          if (snapshot.hasData) {
            return ChatScreen();
          }
          return LoginScreen();
        }
      ),
    );
  }
}

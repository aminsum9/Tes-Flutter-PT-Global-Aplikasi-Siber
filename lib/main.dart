import 'package:donasi_app/pages/home.dart';
import 'package:donasi_app/pages/login.dart';
import 'package:donasi_app/pages/register.dart';
import 'package:donasi_app/pages/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  RouterState createState() => RouterState();
}

class RouterState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const Splash(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          tabBarTheme: const TabBarTheme(
              labelColor: Colors.white,
              labelStyle: TextStyle(color: Colors.white),
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.white))),
          primaryColor: Colors.lightGreen,
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const Register(),
          '/home': (context) => const Home(),
        });
  }
}

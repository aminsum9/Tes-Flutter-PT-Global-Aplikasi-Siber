import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      checkLogin();
    });
  }

  void checkLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token").toString();

      if (token != "" && token != "null") {
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/home');
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/login');
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return const PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SizedBox(
              width: 180,
              height: 180,
              child: Text(
                "Donasi App",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
          ),
        ));
  }
}

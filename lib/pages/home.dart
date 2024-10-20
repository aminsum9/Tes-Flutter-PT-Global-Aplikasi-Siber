import 'dart:convert';

import 'package:donasi_app/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool loading = false;

  String name = '';
  String email = '';
  String baseUrl = '';

  Future<http.Response> getData(Uri url) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    print("token: $token");

    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    return response;
  }

  void _hadleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('id_user');
    prefs.remove('base_url');

    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const Splash()),
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    final prefs = await SharedPreferences.getInstance();
    String baseUrlStorage = prefs.getString('base_url').toString();

    setState(() {
      baseUrl = baseUrlStorage;
    });
    _hadleGetDataProfile(baseUrlStorage);
  }

  void _hadleGetDataProfile(baseUrl) async {
    setState(() {
      loading = true;
    });

    try {
      print("url: ${'${baseUrl}api/auth/get-profile'}");
      final response =
          await getData(Uri.parse('${baseUrl}api/auth/get-profile'));
      print("status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == "success") {
          setState(() {
            name = data['data']['name'];
            email = data['data']['email'];
          });
        } else {
          //
        }
      } else {
        //
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Your Profile"),
              Text("Base URL: $baseUrl", style: const TextStyle(fontSize: 12))
            ],
          ),
          automaticallyImplyLeading: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Name: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Email: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        email,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  )
                ],
              )),
        ),
        bottomNavigationBar: Container(
            height: 100,
            child: Column(
              children: [
                GestureDetector(
                    onTap: () {
                      _hadleLogout();
                    },
                    child: const ButtonLogout())
              ],
            )));
  }
}

class ButtonLogout extends StatelessWidget {
  const ButtonLogout({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      child: const Center(
        child: Text("Log Out",
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.3)),
      ),
    ));
  }
}

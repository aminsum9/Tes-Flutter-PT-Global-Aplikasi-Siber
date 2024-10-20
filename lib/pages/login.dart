import 'package:donasi_app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donasi_app/config/url.dart' as url;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController controllerEmail = TextEditingController(text: '');
  final TextEditingController controllerPassword =
      TextEditingController(text: '');

  var errorMessage = "";
  bool loading = false;

  bool passwordShown = false;

  Future<http.Response> postData(Uri url, dynamic body) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token").toString();

    final response = await http.post(url,
        headers: {'Authorization': 'Bearer $token'}, body: body);
    return response;
  }

  void _hadleLogin() async {
    setState(() {
      loading = true;
    });

    try {
      var body = {
        'email': controllerEmail.text,
        'password': controllerPassword.text
      };

      final response =
          await postData(Uri.parse('${url.baseUrl}auth/login'), body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == "success") {
          String? token = data['token'].toString();
          String? idUser = data['id_user'].toString();
          String? baseUrl = data['base_url'].toString();

          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);
          prefs.setString('id_user', idUser);
          prefs.setString('base_url', baseUrl);

          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, '/home');
        } else {
          setState(() {
            loading = false;
            errorMessage = "login failed";
          });
        }
      } else {
        setState(() {
          loading = false;
          errorMessage = "login failed";
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = "login failed";
      });
    }
  }

  void toRegister() {
    Navigator.pushNamed(context, '/register');
  }

  void handlePasswordShown() {
    setState(() {
      passwordShown = !passwordShown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: [
          Stack(alignment: AlignmentDirectional.bottomCenter, children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 60.0),
                ),
                SizedBox(
                    width: 200,
                    height: MediaQuery.of(context).size.height / 4,
                    child: const Center(
                        child: Text(
                      "Donasi App",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ))),
                const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 40.0),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 15.0),
                            child: TextField(
                              controller: controllerEmail,
                              style: TextStyle(color: Colors.grey[900]),
                              decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.green,
                                  ),
                                  hintText: "Email"),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 20)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 15.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controllerPassword,
                                      obscureText: !passwordShown,
                                      decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black12),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          icon: Icon(
                                            Icons.lock_outline,
                                            color: Colors.green,
                                          ),
                                          hintText: "Password"),
                                    ),
                                  ),
                                  Visibility(
                                    visible: !passwordShown,
                                    child: IconButton(
                                        onPressed: () => handlePasswordShown(),
                                        icon: const Icon(
                                            Icons.remove_red_eye_rounded,
                                            color: Colors.black)),
                                  ),
                                  Visibility(
                                      visible: passwordShown,
                                      child: IconButton(
                                          onPressed: () =>
                                              handlePasswordShown(),
                                          icon: const Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.black)))
                                ],
                              )),
                          const Padding(padding: EdgeInsets.only(bottom: 20)),
                          errorMessage != ""
                              ? Text(errorMessage,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.red))
                              : const Text(""),
                          const Padding(padding: EdgeInsets.only(top: 13)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          toRegister();
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Have no any Account? register ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                                children: [
                                  TextSpan(
                                    text: 'here.',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            _hadleLogin();
                          },
                          child: const SignInButton())
                    ],
                  ),
                ),
              ],
            ),
            Visibility(visible: loading == true, child: const Loading())
          ]),
        ]),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(60.0),
      child: Center(
          child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 50,
        decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: const Center(
          child: Text("Sign In",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.3)),
        ),
      )),
    );
  }
}

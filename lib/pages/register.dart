import 'package:donasi_app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donasi_app/config/url.dart' as url;
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

enum SelectedDatabase { sumur, rumah }

class RegisterState extends State<Register> {
  TextEditingController controllerNama = TextEditingController(text: '');
  TextEditingController controllerEmail = TextEditingController(text: '');
  TextEditingController controllerPassword = TextEditingController(text: '');

  SelectedDatabase? _database = SelectedDatabase.sumur;
  String selectedDatabase = "sumur";

  bool loading = false;
  bool passwordShown = false;

  Future<http.Response> postData(Uri url, dynamic body) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token").toString();

    final response = await http.post(url,
        headers: {'Authorization': 'Bearer $token'}, body: body);
    return response;
  }

  void handleRegister() async {
    try {
      setState(() {
        loading = true;
      });
      var body = {
        'name': controllerNama.text,
        'email': controllerEmail.text,
        'password': controllerPassword.text,
        'database': selectedDatabase
      };

      final response =
          await postData(Uri.parse('${url.baseUrl}auth/register'), body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == "success") {
          setState(() {
            loading = false;
          });

          String? token = data['token'].toString();
          String? idUser = data['id_user'].toString();
          String? baseUrl = data['base_url'].toString();

          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);
          prefs.setString('id_user', idUser);
          prefs.setString('base_url', baseUrl);

          Navigator.pushNamed(context, '/home');
        } else {
          setState(() {
            loading = false;
          });
        }
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  void handlePasswordShown() {
    setState(() {
      passwordShown = !passwordShown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          shadowColor: Colors.transparent,
        ),
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              ListView(children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      TextField(
                        controller: controllerNama,
                        style: TextStyle(color: Colors.grey[900]),
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            icon: Icon(
                              Icons.person,
                              color: Colors.green,
                            ),
                            hintText: "Name"),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      TextField(
                        controller: controllerEmail,
                        style: TextStyle(color: Colors.grey[900]),
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            icon: Icon(
                              Icons.email,
                              color: Colors.green,
                            ),
                            hintText: "Email"),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controllerPassword,
                              obscureText: !passwordShown,
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
                                  hintText: "Password"),
                            ),
                          ),
                          Visibility(
                            visible: !passwordShown,
                            child: IconButton(
                                onPressed: () => handlePasswordShown(),
                                icon: const Icon(Icons.remove_red_eye_rounded,
                                    color: Colors.black)),
                          ),
                          Visibility(
                              visible: passwordShown,
                              child: IconButton(
                                  onPressed: () => handlePasswordShown(),
                                  icon: const Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.black)))
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      const Text(
                        "Database: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                      ),
                      Column(
                        children: [
                          ListTile(
                            title: const Text('sumur'),
                            leading: Radio<SelectedDatabase>(
                              value: SelectedDatabase.sumur,
                              groupValue: _database,
                              onChanged: (SelectedDatabase? value) {
                                setState(() {
                                  _database = value;
                                  selectedDatabase = "sumur";
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('rumah'),
                            leading: Radio<SelectedDatabase>(
                              value: SelectedDatabase.rumah,
                              groupValue: _database,
                              onChanged: (SelectedDatabase? value) {
                                setState(() {
                                  _database = value;
                                  selectedDatabase = "rumah";
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ]),
              Visibility(visible: loading == true, child: const Loading())
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Center(
                  child: GestureDetector(
                onTap: () {
                  handleRegister();
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.green,
                  ),
                  child: const Center(
                    child:
                        Text("Sign Up", style: TextStyle(color: Colors.white)),
                  ),
                ),
              )),
              Visibility(
                  visible: loading,
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    color: const Color.fromRGBO(1, 1, 1, 0.5),
                  ))
            ],
          ),
        ));
  }
}

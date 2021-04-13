import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/bloc/bloc_event.dart';
import 'package:todo/bloc/bloc_file.dart';
import 'package:todo/bloc/bloc_state.dart';

import '../homepage.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController username = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');
  TextEditingController password1 = TextEditingController(text: '');
  TextEditingController error = TextEditingController(text: '');
  SharedPreferences prefs;
  var dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Sign Up",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26),
          ),
        ),
        body: SingleChildScrollView(
          child: Builder(
            builder: (c) {
              return BlocListener<DataBloc, DataState>(
                  child: buildContainer(c),
                  listener: (context1, state) {
                    if (state is ResponseDataState) {
                      log(state.code.toString());
                      if (state.code != 'Wrong credentials') {
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) {
                          return MyHomePage(
                            token: state.code,
                          );
                        }));
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Text("Wrong Credentials.."),
                                ),
                              );
                            }).whenComplete(() {
                          Navigator.pop(context);
                        });
                      }
                    } else if (state is IsLoading) {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return Dialog(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text("Loading...."),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else if (state is InitialState) {
                      return buildContainer(c);
                    } else if (state is ErrorState) {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text("Username Already Taken"),
                              ),
                            );
                          }).whenComplete(() {
                        Navigator.pop(context);
                      });
                    }
                  });
            },
          ),
        ));
  }

  buildContainer(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            margin: EdgeInsets.all(9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                    controller: username,
                    decoration: InputDecoration(labelText: "Username")),
                TextFormField(
                    obscureText: true,
                    controller: password,
                    decoration: InputDecoration(labelText: "Password")),
                TextFormField(
                    obscureText: true,
                    controller: password1,
                    decoration: InputDecoration(labelText: "Confirm Password")),
                SizedBox(height: 17),
                FloatingActionButton.extended(
                  onPressed: () {
                    if (password.text == password1.text) {
                      BlocProvider.of<DataBloc>(context).add(SignUpRequest(
                          password: password.text, username: username.text));
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Password not matched"),
                      ));
                    }
                  },
                  label: Text("SignUp",
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  icon: Icon(Icons.send),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return Login();
                      }));
                    },
                    child: Text("Log In instead",
                        style: TextStyle(decoration: TextDecoration.underline)),
                  ),
                ),
                ListTile(
                    title: Center(
                        child: Text("${error.text}",
                            style: TextStyle(color: Colors.red)))),
              ],
            ),
          ),
        ));
  }
}

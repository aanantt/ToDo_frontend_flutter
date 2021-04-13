import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/authentication/signup.dart';
import 'package:todo/bloc/bloc_event.dart';
import 'package:todo/bloc/bloc_file.dart';
import 'package:todo/bloc/bloc_state.dart';

import '../homepage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');
  TextEditingController error = TextEditingController(text: '');
  SharedPreferences prefs;
  var dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Log In",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: BlocListener<DataBloc, DataState>(
          child: buildContainer(context, error.text),
          listener: (context1, state) {
            if (state is ResponseDataState) {
              if (state.code != 'Wrong credentials') {
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
              return buildContainer(context, '');
            }
          }),
    );
  }

  buildContainer(BuildContext context, String error) {
    return Container(
        padding: EdgeInsets.all(3),
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
                SizedBox(height: 17),
                FloatingActionButton.extended(
                  onPressed: () {
                    context.bloc<DataBloc>().add(LoginRequest(
                        password: password.text, username: username.text));
                  },
                  label: Text("LogIn",
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  icon: Icon(Icons.send),
                ),
                SizedBox(height: 17),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return Signup();
                      }));
                    },
                    child: Text("First Time?? click here",
                        style: TextStyle(decoration: TextDecoration.underline)),
                  ),
                ),
                ListTile(
                    title: Center(
                        child: Text("$error",
                            style: TextStyle(color: Colors.red)))),
              ],
            ),
          ),
        ));
  }
}

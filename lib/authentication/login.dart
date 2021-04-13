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
        backgroundColor: Colors.transparent,
        title: Text(
          "Log In",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: BlocListener<DataBloc, DataState>(
          child: buildContainer(context, error.text),
          listener: (context1, state) {
             if (state is ResponseDataState) {
              if (state.code!= 'Wrong credentials') {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                  return MyHomePage(
                    token: state.code,
                  );
                }));
              } else {
                showDialog(
                    context: context,
                    builder: (_) {
                      return Dialog(
                        child: Text("ERROR_WRONG_PASSWORD"),
                      );
                    });
              }
            } else if (state is IsLoading) {
              error.text = 'Loading...';
            } else if (state is InitialState) {
              return buildContainer(context, '');
            }
          }),
    );
  }

  buildContainer(BuildContext context, String error) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                  controller: username,
                  decoration: InputDecoration(labelText: "Username")),
              TextFormField(
                  controller: password,
                  decoration: InputDecoration(labelText: "Password")),
              SizedBox(height: 10),
              BlocListener<DataBloc, DataState>(
                listener: (BuildContext context1, DataState state) {},
                child: MaterialButton(
                    color: Colors.blue,
                    onPressed: () async {
                      context.bloc<DataBloc>().add(LoginRequest(
                          password: password.text, username: username.text));
                    },
                    child:
                        Text("Login", style: TextStyle(color: Colors.white))),
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Text("Forgot Password"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return Signup();
                      }));
                    },
                    child: Text("First Time??"),
                  ),
                ),
              ]),
              ListTile(
                  title: Center(
                      child:
                          Text("$error", style: TextStyle(color: Colors.red)))),
            ],
          ),
        ));
  }
}

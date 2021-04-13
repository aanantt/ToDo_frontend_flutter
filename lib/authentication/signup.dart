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
          "Sign Up",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: BlocListener<DataBloc, DataState>(
          child: buildContainer(context),
          listener: (context1, state) {
            if (state is ResponseDataState) {
              log(state.code.toString());
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
                          padding: const EdgeInsets.all(8.0),
                          child: Text(state.code.toString()),
                        ),
                      );
                    });
              }
            } else if (state is IsLoading) {
              error.text = 'Loading...';
            } else if (state is InitialState) {
              return buildContainer(context);
            } else if (state is ErrorState) {
              showDialog(
                  context: context,
                  builder: (_) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(state.error.toString()),
                      ),
                    );
                  });
            }
          }),
    );
  }

  buildContainer(BuildContext context) {
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
              MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    BlocProvider.of<DataBloc>(context).add(SignUpRequest(
                        password: password.text, username: username.text));
                    // context.bloc<DataBloc>().add( );
                  },
                  child:
                      Text("Sign Up", style: TextStyle(color: Colors.white))),
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
                        return Login();
                      }));
                    },
                    child: Text("LogIn instead"),
                  ),
                ),
              ]),
              ListTile(
                  title: Center(
                      child: Text("${error.text}",
                          style: TextStyle(color: Colors.red)))),
            ],
          ),
        ));
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/bloc_event.dart';
import 'bloc/bloc_file.dart';
import 'repository/repository.dart';
import 'homepage.dart';
import 'authentication/login.dart';
import 'model/model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String val = _prefs.getString("token") ?? "empty";
  log(val);
  runApp(MultiBlocProvider(providers: [
    BlocProvider<DataBloc>(
      create: (context) =>
          DataBloc(articleRepositoryImpl: DataRepositoryImpl()),
    ),
  ], child: MyApp(val: val)));
}

class MyApp extends StatelessWidget {
  final val;

  const MyApp({Key key, this.val}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: val != 'empty'
          ? BlocProvider(
              create: (context) =>
                  DataBloc(articleRepositoryImpl: DataRepositoryImpl())
                    ..add(GetDataRequest(val)),
              child: MyHomePage(
                token:val,
              ),
            )
          : BlocProvider(
              create: (context) =>
                  DataBloc(articleRepositoryImpl: DataRepositoryImpl())
                    ..add(Initial()),
              child: Login(),
            ),
    );
  }
}

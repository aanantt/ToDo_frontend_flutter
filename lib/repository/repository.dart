import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/model.dart';
import 'package:http/http.dart' as http;

abstract class DataRepository {
  Future<List<Todo>> getData(String token);
  Future<int> postData(String token, String work);
  Future<int> putData(String token, int id);
  Future<int> deleteData(String token, int id);
  Future<String> loginData(String username, String password);
  Future<int> signupData(String username, String password);
}

class DataRepositoryImpl implements DataRepository {
  List<Todo> dataa = [];
  String url = 'url';

  @override
  Future<List<Todo>> getData(String token) async {
    List<Todo> todo = [];
    final response = await http.get(
      '$url/api/todo/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
    );
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      data.forEach((element) {
        todo.add(Todo.fromjson(element));
      });
    }
    return todo;
  }

  @override
  Future<int> postData(String token, String work) async {
    var body = jsonEncode({'work': work});
    final response = await http.post(
      '$url/api/todo/',
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
    );
    log(response.statusCode.toString());
    return response.statusCode;
  }

  @override
  Future<int> deleteData(String token, int id) async {
    final response = await http.delete(
      '$url/api/todo/$id/',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
    );
    return response.statusCode;
  }

  @override
  Future<String> loginData(String username, String password) async {
    String result = '';
    var body = jsonEncode({'username': username, 'password': password});
    final response = await http.post(
      '$url/api/login/',
      body: body,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      print(responseJson["token"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseJson["token"].toString());
      result = responseJson["token"].toString();
    } else {
      result = 'Wrong credentials';
    }
    return result;
  }

  @override
  Future<int> putData(String token, int id) async {
    var body = jsonEncode({'isdone': true});
    final response = await http.put(
      '$url/api/todo/$id/',
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
    );
    return response.statusCode;
  }

  @override
  Future<int> signupData(String username, String password) async {
    var body = jsonEncode({'username': username, 'password': password});
    final response = await http.post(
      '$url/api/user/signup/',
      body: body,
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode;
  }
}

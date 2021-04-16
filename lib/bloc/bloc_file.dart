import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/bloc_event.dart';
import 'package:todo/bloc/bloc_state.dart';
import 'package:todo/repository/repository.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final DataRepositoryImpl articleRepositoryImpl;

  DataBloc({this.articleRepositoryImpl});

  @override
  DataState get initialState => InitialState();

  @override
  Stream<DataState> mapEventToState(DataEvent event) async* {
    if (event is GetDataRequest) {
      yield* getstate(event);
    } else if (event is PostData) {
      await articleRepositoryImpl.postData(event.token, event.work);
      final todoList = await articleRepositoryImpl.getData(event.token);
      yield GetDataState(todo: todoList);
    } else if (event is UpdateData) {
      await articleRepositoryImpl.putData(event.token, event.id);
      final todoList = await articleRepositoryImpl.getData(event.token);
      yield GetDataState(todo: todoList);
    } else if (event is DeleteData) {
      await articleRepositoryImpl.deleteData(event.token, event.id);
      final todoList = await articleRepositoryImpl.getData(event.token);
      yield GetDataState(todo: todoList);
    } else if (event is LoginRequest) {
      yield IsLoading();
      final response =
          await articleRepositoryImpl.loginData(event.username, event.password);
      log(response);
      yield ResponseDataState(code: response);
    } else if (event is SignUpRequest) {
      yield IsLoading();
      final response = await articleRepositoryImpl.signupData(
          event.username, event.password);
      if (response == 201) {
        log('now logging in');
        final response1 = await articleRepositoryImpl.loginData(
            event.username, event.password);
        log('logged in');
        yield ResponseDataState(code: response1);
      } else {
        log('now error in');
        yield ErrorState(error: response);
      }
    }
  }

  Stream<DataState> getstate(event) async* {
    yield IsLoading();
    final todoList = await articleRepositoryImpl.getData(event.token);
    yield GetDataState(todo: todoList);
  }
}

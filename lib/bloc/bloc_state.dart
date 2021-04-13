import 'package:equatable/equatable.dart';

import '../model/model.dart';

abstract class DataState extends Equatable {}

class GetDataState extends DataState {
  final List<Todo> todo;
  GetDataState({this.todo});
  @override
  List<Object> get props => [todo];
}

class PostDataState extends DataState {
  @override
  List<Object> get props => [];
}

class ResponseDataState extends DataState {
  final code;

  ResponseDataState({this.code});
  @override
  List<Object> get props => [code];
}

class UpdateDataState extends DataState {
  @override
  List<Object> get props => [];
}

class DeleteDataState extends DataState {
  @override
  List<Object> get props => [];
}

class ErrorState extends DataState {
  final error;

  ErrorState({this.error});
  @override
  List<Object> get props => [error];
}

class IsLoading extends DataState {
  @override
  List<Object> get props => [];
}

class InitialState extends DataState {
  @override
  List<Object> get props => [];
}

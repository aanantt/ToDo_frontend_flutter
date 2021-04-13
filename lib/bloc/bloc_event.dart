import 'package:equatable/equatable.dart';

abstract class DataEvent extends Equatable {}

class GetDataRequest extends DataEvent {
  final String token;

  GetDataRequest(this.token);
  @override
  List<Object> get props => [token];
}

 

class PostData extends DataEvent {
  final String work;
  final String token;
  PostData({this.work, this.token});
  @override
  List<Object> get props => [work, token];
}

class UpdateData extends DataEvent {
  final String token;
  final int id;

  UpdateData({this.token, this.id});
  @override
  List<Object> get props => [token, id];
}

class Initial extends DataEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DeleteData extends DataEvent {
  final String token;
  final int id;
  DeleteData({this.token, this.id});
  @override
  List<Object> get props => [token, id];
}

class LoginRequest extends DataEvent {
  final String username;
  final String password;

  LoginRequest({this.username, this.password});
  @override
  List<Object> get props => [username, password];
}

class SignUpRequest extends DataEvent {
  final String username;
  final String password;
  SignUpRequest({this.username, this.password});
  @override
  List<Object> get props => [username, password];
}

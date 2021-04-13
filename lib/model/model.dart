class Todo {
  final int id;
  final String work;
  final bool isdone;
  final int user;

  Todo({this.id, this.work, this.isdone, this.user});

  factory Todo.fromjson(Map<dynamic, dynamic> json) {
    return Todo(
        id: json["id"],
        work: json["work"],
        isdone: json["isdone"],
        user: json["user"]);
  }
}

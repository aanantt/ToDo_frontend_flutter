import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/bloc/bloc_event.dart';

import 'authentication/login.dart';
import 'bloc/bloc_file.dart';
import 'bloc/bloc_state.dart';
import 'model/model.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.token}) : super(key: key);
  final String token;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TextEditingController work = TextEditingController(text: '');
  Stream<List<Todo>> data;

  @override
  void initState() {
    BlocProvider.of<DataBloc>(context).add(GetDataRequest(widget.token));
    super.initState();
  }

  showSheet(BuildContext c) {
    showBottomSheet(
        context: c,
        builder: (c) {
          return Container(
            padding: EdgeInsets.all(5),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: true,
                      controller: work,
                      decoration: InputDecoration(labelText: "Work"),
                    ),
                  ),
                  MaterialButton(
                      color: Colors.blue,
                      onPressed: () async {
                        // await submitdata();
                        BlocProvider.of<DataBloc>(context).add(PostData(
                          work: work.text,
                          token: widget.token,
                        ));
                        work.clear();
                        Navigator.pop(context);
                      },
                      child: Text("Add", style: TextStyle(color: Colors.white)))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(builder: (c) {
        return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showSheet(c);
          },
        );
      }),
      appBar: AppBar(title: Text("ToDo"), actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () async {
            BlocProvider.of<DataBloc>(context)
                .add(GetDataRequest(widget.token));
          },
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () async {
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            _prefs.remove("token");
            Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) {
              return Login();
            }));
          },
        ),
      ]),
      body: BlocBuilder<DataBloc, DataState>(
        builder: (context, state) {
          return whichWidget(context, state);
        },
      ),
    );
  }

  Widget whichWidget(context, state) {
    if (state is InitialState) {
      return buildContainer(context, []);
    } else if (state is GetDataState) {
      return buildContainer(context, state.todo);
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget buildContainer(BuildContext context, List data) {
    return Container(
      child: data.length != 0
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Builder(
                  builder: (cv) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Card(
                        elevation: 4,
                        child: ListTile(
                          onLongPress: () {
                            showDialog(
                                context: cv,
                                builder: (cv) {
                                  return Dialog(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                            onTap: () {
                                              BlocProvider.of<DataBloc>(context)
                                                  .add(UpdateData(
                                                token: widget.token,
                                                id: data[index].id,
                                              ));
                                              // await updateData(
                                              //     snapshot.data[index].id);
                                              Navigator.pop(context);
                                            },
                                            title: Text("Mark completed")),
                                        ListTile(
                                            onTap: () {
                                              BlocProvider.of<DataBloc>(context)
                                                  .add(DeleteData(
                                                token: widget.token,
                                                id: data[index].id,
                                              ));
                                              // await deleteData(
                                              //     snapshot.data[index].id);
                                              Navigator.pop(context);
                                            },
                                            title: Text("delete")),
                                      ],
                                    ),
                                  );
                                });
                          },
                          title: Text(
                            data[index].work,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                decoration: data[index].isdone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                          trailing: data[index].isdone
                              ? Icon(Icons.check, color: Colors.green)
                              : SizedBox(),
                        ),
                      ),
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Complete',
                          color: Colors.black45,
                          icon: Icons.check,
                          onTap: () =>
                              BlocProvider.of<DataBloc>(context).add(UpdateData(
                            token: widget.token,
                            id: data[index].id,
                          )),
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () =>
                              BlocProvider.of<DataBloc>(context).add(DeleteData(
                            token: widget.token,
                            id: data[index].id,
                          )),
                        ),
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Complete',
                          color: Colors.black45,
                          icon: Icons.check,
                          onTap: () =>
                              BlocProvider.of<DataBloc>(context).add(UpdateData(
                            token: widget.token,
                            id: data[index].id,
                          )),
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () =>
                              BlocProvider.of<DataBloc>(context).add(DeleteData(
                            token: widget.token,
                            id: data[index].id,
                          )),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          : Center(
              child: Text("No TODOs"),
            ),
    );
  }
}

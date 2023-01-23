import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_hour/blocs/comments_bloc.dart';
import 'package:travel_hour/blocs/internet_bloc.dart';
import 'package:travel_hour/blocs/place_bloc.dart';
import 'package:travel_hour/utils/empty.dart';
import 'package:travel_hour/utils/toast.dart';

class CommentsPage extends StatefulWidget {
  final String title;
  final String timestamp;
  const CommentsPage({Key key, @required this.title, @required this.timestamp})
      : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  var formKey = GlobalKey<FormState>();
  var textFieldCtrl = TextEditingController();
  String comment;

  void handleSubmit(cb) {
    final PlaceBloc pb = Provider.of<PlaceBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);

    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (ib.hasInternet == false) {
        openToast(context, 'No internet');
      } else {
        if (widget.title == 'User Reviews') {
          cb.saveNewComment(widget.timestamp, 'places', comment);
          pb.getCommentsAmount(widget.timestamp);
          pb.commentsIncrement(widget.timestamp);
        } else {
          cb.saveNewComment(widget.timestamp, 'blogs', comment);
        }
      }
      textFieldCtrl.clear();
      FocusScope.of(context).requestFocus(new FocusNode());
    }
  }

  handleDelete(uid, timestamp2) async {
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    final PlaceBloc pb = Provider.of<PlaceBloc>(context);

    final CommentsBloc cb = Provider.of<CommentsBloc>(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Delete?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: Text('Want to delete this comment?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () async {
                  Navigator.pop(context);
                  await ib.checkInternet();
                  if (ib.hasInternet == false) {
                    openToast(context, 'No internet connection');
                  } else {
                    final SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    String _uid = sp.getString('uid');
                    if (uid != _uid) {
                      openToast(context, 'You can not delete others comment');
                    } else {
                      if (widget.title == 'User Reviews') {
                        await cb.deleteComment(
                            widget.timestamp, 'places', uid, timestamp2);
                        openToast(context, 'Deleted Successfully');

                        await pb.getCommentsAmount(widget.timestamp);
                        pb.commentsDecrement(widget.timestamp);
                      } else {
                        await cb.deleteComment(
                            widget.timestamp, 'blogs', uid, timestamp2);
                        openToast(context, 'Deleted Successfully');
                      }
                    }
                  }
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final CommentsBloc cb = Provider.of<CommentsBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
        elevation: 1,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: widget.title == 'User Reviews'
                  ? cb.getData(widget.timestamp, 'places')
                  : cb.getData(widget.timestamp, 'blogs'),
              builder: (BuildContext context, AsyncSnapshot<List> snap) {
                if (snap.connectionState == ConnectionState.none)
                  return emptyPage(Icons.signal_wifi_off, 'No Internet');
                else {
                  if (!snap.hasData)
                    return Center(child: CircularProgressIndicator());
                  if (snap.hasError)
                    return emptyPage(Icons.error_outline, 'Something is wrong');
                  if (snap.data.isEmpty)
                    return emptyPage(Icons.mode_comment, 'No comment found!');

                  List d = snap.data;
                  d.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

                  return ListView.builder(
                    padding: EdgeInsets.all(15),
                    itemCount: snap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: CachedNetworkImageProvider(
                                  d[index]['image url']),
                            ),
                            title: Row(
                              children: <Widget>[
                                Text(
                                  d[index]['name'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(d[index]['date'],
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                            subtitle: Text(
                              d[index]['comment'],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                            onLongPress: () {
                              handleDelete(
                                  d[index]['uid'], d[index]['timestamp']);
                            },
                          ));
                    },
                  );
                }
              },
            ),
          ),
          Divider(
            height: 1,
            color: Colors.black26,
          ),
          SafeArea(
            child: Container(
              height: 65,
              padding: EdgeInsets.only(top: 8, bottom: 10, right: 20, left: 20),
              width: double.infinity,
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25)),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 0),
                        contentPadding:
                            EdgeInsets.only(left: 15, top: 10, right: 5),
                        border: InputBorder.none,
                        hintText: 'Write a comment',
                        //prefixIcon: Icon(Icons.comment, size:20, color:Colors.deepPurpleAccent),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.grey[700],
                            size: 20,
                          ),
                          onPressed: () {
                            handleSubmit(cb);
                          },
                        )),
                    controller: textFieldCtrl,
                    onSaved: (String value) {
                      setState(() {
                        this.comment = value;
                      });
                    },
                    validator: (value) {
                      if (value.length == 0) return 'nullllll';
                      return null;
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

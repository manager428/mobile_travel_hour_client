import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CommentsBloc extends ChangeNotifier{

  
  String date;
  String timestamp1;
  List _data = [];

  set data (newData){
    _data = newData;
  }

  List get data => _data;



  Future<List> getData(timestamp, types) async {


    QuerySnapshot snap = await Firestore.instance.collection('$types/$timestamp/comments').getDocuments();
    var x = snap.documents;
    List data = [];
    x.forEach((f) => data.add(f));
    return data;
   }





    


  Future saveNewComment(timestamp,types, comment)async{

    final SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');
    String _name = sp.getString('name');
    String _imageUrl = sp.getString('image url');


    await _getDate().then((_){
      Firestore.instance.collection('$types/$timestamp/comments').document('$_uid$timestamp1').setData({
        'name': _name,
        'comment' : comment,
        'date' : date,
        'image url' : _imageUrl,
        'timestamp': timestamp1,
        'uid' : _uid
      });
    });
    

    getData(timestamp, types);
    

  }


  Future deleteComment (timestamp, types, uid, timestamp2) async{
    
    Firestore.instance.collection('$types/$timestamp/comments').document('$uid$timestamp2').delete();
    getData(timestamp, types);
  }


  Future _getDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat('dd MMMM yy').format(now);
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    date = _date;
    timestamp1 = _timestamp;
  }


}
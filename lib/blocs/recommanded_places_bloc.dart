import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RecommandedPlacesBloc extends ChangeNotifier {
  List _data = [];
  List get data => _data;
  set data(newData) => _data = newData;

  RecommandedPlacesBloc() {
    getData();
  }

  Future getData() async {
    QuerySnapshot snap =
        await Firestore.instance.collection('places').getDocuments();
    var x = snap.documents;
    _data.clear();
    x.forEach((f) {
      if (f['category'] != 4) {
        _data.add(f);
      }
    });
    _data.shuffle();
    notifyListeners();
  }
}

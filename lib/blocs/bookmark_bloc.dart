import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkBloc extends ChangeNotifier {

  
  List _blogData = [];
  List get blogData => _blogData;
  set blogData(newData) => _blogData = newData;
  

  List _placeData = [];
  List get placeData => _placeData;
  set placeData(newData1) => _placeData = newData1;

  
  
  
  Future getBlogData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');

    final DocumentReference ref = Firestore.instance.collection('users').document(_uid);
    DocumentSnapshot snap = await ref.get();
    List d = snap.data['bookmarked blogs'];

    _blogData.clear();

    Firestore.instance
        .collection('blogs')
        .getDocuments()
        .then((QuerySnapshot snap) {
      var x = snap.documents;
      for (var item in x) {
        if (d.contains(item['timestamp'])) {
          _blogData.add(item);
        }
      }
      notifyListeners();
    });
  }



  Future getPlaceData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');

    final DocumentReference ref = Firestore.instance.collection('users').document(_uid);
    DocumentSnapshot snap = await ref.get();
    List d = snap.data['bookmarked places'];

    _placeData.clear();

    Firestore.instance
        .collection('places')
        .getDocuments()
        .then((QuerySnapshot snap) {
      var x = snap.documents;
      for (var item in x) {
        if (d.contains(item['timestamp'])) {
          _placeData.add(item);
        }
      }
      notifyListeners();
    });
  }






}

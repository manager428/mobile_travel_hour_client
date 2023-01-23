import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_hour/models/icon_data.dart';
import 'package:travel_hour/utils/toast.dart';

class PlaceBloc extends ChangeNotifier {
  List _data = [];

  bool _hasData = false;
  int _loves = 0;
  int _commentCount = 0;
  Icon _loveIcon = LoveIcon().normal;
  Icon _bookmarIcon = BookmarkIcon().normal;
  List _filteredData = [];
  List _lovedPlaces = [];
  List _bookmarkedPlaces = [];
  List _addsData = [];

  PlaceBloc() {
    getData();
    getAddsData();
  }

  set data(newValue) {
    _data = newValue;
  }
  set addsData(newValue) {
    _addsData = newValue;
  }
  
  set hasData(data) {
    _hasData = data;
  }

  set loves(newLoves) {
    _loves = newLoves;
  }

  set loveIcon(newLoveIcon) {
    _loveIcon = newLoveIcon;
  }

  set bookmarkIcon(newBookmarkIcon) {
    _bookmarIcon = newBookmarkIcon;
  }

  set filteredData(newData) {
    _filteredData = newData;
  }

  set commentsCount(newComment) {
    _commentCount = newComment;
  }

  set lovedPlaces(newItem) => _lovedPlaces = newItem;
  set bookmarkedPlaces(newValue) => _bookmarkedPlaces = newValue;

  List get data => _data;
  List get addsData => _addsData;
  bool get hasData => _hasData;
  int get loves => _loves;
  Icon get loveIcon => _loveIcon;
  Icon get bookmarkIcon => _bookmarIcon;
  List get filteredData => _filteredData;
  int get commentsCount => _commentCount;
  List get lovedPlaces => _lovedPlaces;
  List get bookmarkedPlaces => _bookmarkedPlaces;

  void getAddsData() async {
    Firestore.instance
        .collection('adds')
        .document('adds-images')
        .get()
        .then((DocumentSnapshot snap) {
         
      _addsData = snap.data['adds-images'];
      notifyListeners();
    });
  }
  Future getData() async {
    QuerySnapshot snap =
        await Firestore.instance.collection('places').getDocuments();
    var x = snap.documents;
    _data.clear();

    x.forEach((f) {
      _data.add(f);
    });
    data.shuffle();
  }

  Future getLovedList() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');

    final DocumentReference ref =
        Firestore.instance.collection('users').document(_uid);
    DocumentSnapshot snap = await ref.get();
    List d = snap.data['loved places'];
    _lovedPlaces = d;

    notifyListeners();
  }

  Future getBookmarkedList() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');

    final DocumentReference ref =
        Firestore.instance.collection('users').document(_uid);
    DocumentSnapshot snap = await ref.get();
    List d = snap.data['bookmarked places'];
    _bookmarkedPlaces = d;

    notifyListeners();
  }

  Future getLovesAmount(timestamp) async {
    final DocumentReference ref =
        Firestore.instance.collection('places').document(timestamp);
    DocumentSnapshot snap = await ref.get();
    int loves = snap['loves'];
    _loves = loves;
    notifyListeners();
  }

  Future getCommentsAmount(timestamp) async {
    final DocumentReference ref =
        Firestore.instance.collection('places').document(timestamp);
    DocumentSnapshot snap = await ref.get();
    int comments = snap['comments count'];
    _commentCount = comments;
    notifyListeners();
  }

  Future commentsIncrement(timestamp) async {
    Firestore.instance
        .collection('places')
        .document(timestamp)
        .updateData({'comments count': _commentCount + 1});
  }

  Future commentsDecrement(timestamp) async {
    Firestore.instance
        .collection('places')
        .document(timestamp)
        .updateData({'comments count': _commentCount - 1});
  }

  void loveIconCheck(timestamp) async {
    if (_lovedPlaces.contains(timestamp)) {
      _loveIcon = LoveIcon().bold;
    } else {
      _loveIcon = LoveIcon().normal;
    }
    notifyListeners();
  }

  Future bookmarkIconCheck(timestamp) async {
    if (_bookmarkedPlaces.contains(timestamp)) {
      _bookmarIcon = BookmarkIcon().bold;
    } else {
      _bookmarIcon = BookmarkIcon().normal;
    }
    notifyListeners();
  }

  loveIconClicked(timestamp) async {
    final DocumentReference ref =
        Firestore.instance.collection('places').document(timestamp);

    if (_lovedPlaces.contains(timestamp)) {
      _removeFromLove(timestamp);

      await getLovedList();
      loveIconCheck(timestamp);
      ref.updateData({'loves': _loves - 1});
      getLovesAmount(timestamp);
    } else {
      _addtoLove(timestamp);

      await getLovedList();
      loveIconCheck(timestamp);
      ref.updateData({'loves': _loves + 1});
      getLovesAmount(timestamp);
    }

    notifyListeners();
  }

  void _addtoLove(timestamp) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');
    final DocumentReference ref =
        Firestore.instance.collection('users').document(_uid);

    List firstItem = [timestamp];

    if (_lovedPlaces == null) {
      ref.updateData({'loved places': FieldValue.arrayUnion(firstItem)});
    } else {
      _lovedPlaces.add(timestamp);
      ref.updateData({'loved places': FieldValue.arrayUnion(_lovedPlaces)});
    }

    notifyListeners();
  }

  void _removeFromLove(timestamp) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');
    final DocumentReference ref =
        Firestore.instance.collection('users').document(_uid);
    List d = [timestamp];
    ref.updateData({'loved places': FieldValue.arrayRemove(d)});
  }

  void _addtoBookmark(timestamp, context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');
    final DocumentReference ref =
        Firestore.instance.collection('users').document(_uid);

    List firstItem = [timestamp];

    if (_bookmarkedPlaces == null) {
      ref.updateData({'bookmarked places': FieldValue.arrayUnion(firstItem)});
    } else {
      _bookmarkedPlaces.add(timestamp);
      ref.updateData(
          {'bookmarked places': FieldValue.arrayUnion(_bookmarkedPlaces)});
    }
    openToast(context, 'Added to your bookmark');

    notifyListeners();
  }

  void _removeFromBookmark(timestamp, context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');
    final DocumentReference ref =
        Firestore.instance.collection('users').document(_uid);
    List d = [timestamp];
    ref.updateData({'bookmarked places': FieldValue.arrayRemove(d)});
    openToast(context, 'Removed from your bookmark');
  }

  Future bookmarkIconClicked(timestamp, context) async {
    if (_bookmarkedPlaces.contains(timestamp)) {
      _removeFromBookmark(timestamp, context);
      await getBookmarkedList();
      bookmarkIconCheck(timestamp);
    } else {
      _addtoBookmark(timestamp, context);
      await getBookmarkedList();
      bookmarkIconCheck(timestamp);
    }

    notifyListeners();
  }

  afterSearch(value) {
    _filteredData = _data
        .where((u) =>
            (u['place name'].toLowerCase().contains(value.toLowerCase()) ||
                u['location'].toLowerCase().contains(value.toLowerCase()) ||
                u['description'].toLowerCase().contains(value.toLowerCase())))
        .toList();

    notifyListeners();
  }
}

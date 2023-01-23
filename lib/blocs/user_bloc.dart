import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends ChangeNotifier{

  
  String _name;
  String get name => _name;
  set setName(String name) => _name = name;

  String _email;
  String get email => _email;
  set setEmail(String email) => _email = email;

  String _imageUrl;
  String get imageUrl => _imageUrl;
  set setImageUrl(String imageUrl) => _imageUrl = imageUrl;

  String _uid;
  String get getUid => _uid;
  set setUid(String uid) => _uid = uid;
  
  String _joiningDate;
  String get joiningDate => _joiningDate;
  set setJoiningDate(String value) => _joiningDate = value;



  getUserData () async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String _userUid = sp.getString('uid');
    String _userEmail = sp.getString('email');
    String _userName = sp.getString('name');
    String _userImageUrl = sp.getString('image url');
    
    Firestore.instance.collection('users').document(_userUid).get().then((DocumentSnapshot snap) {
      String _userJoiningDate = snap.data['joining date'];
      _joiningDate = _userJoiningDate;
    });
    

    _uid = _userUid;
    _email = _userEmail;
    _name = _userName;
    _imageUrl = _userImageUrl;
    
    
    notifyListeners();
    
  }




  Future updateNewData (newName, newImageUrl) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');
    Firestore.instance.collection('users').document(_uid).updateData({'image url' : newImageUrl, 'name': newName});
    await sp.setString('name', newName);
    await sp.setString('image url', newImageUrl);
    _name = newName;
    _imageUrl = newImageUrl;
    notifyListeners();

  }


}
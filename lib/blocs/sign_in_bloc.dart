import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInBloc extends ChangeNotifier {
  SignInBloc() {
    checkSignIn();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  final FacebookLogin fbLogin = new FacebookLogin();

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  set isSignedIn(newVal) => _isSignedIn = newVal;

  bool _hasError = false;
  bool get hasError => _hasError;
  set hasError(newError) => _hasError = newError;

  String _errorCode;
  String get errorCode => _errorCode;
  set errorCode(newCode) => _errorCode = newCode;

  bool _userExists = false;
  bool get userExists => _userExists;
  set setUserExist(bool value) => _userExists = value;

  String _name;
  String get name => _name;
  set setName(newName) => _name = newName;

  String _uid;
  String get uid => _uid;
  set setUid(newUid) => _uid = newUid;

  String _email;
  String get email => _email;
  set setEmail(newEmail) => _email = newEmail;

  String _imageUrl;
  String get imageUrl => _imageUrl;
  set setImageUrl(newImageUrl) => _imageUrl = newImageUrl;

  String _joiningDate;
  String get joiningDate => _joiningDate;
  set setJoiningDate(newDate) => _joiningDate = newDate;

  Future signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthProvider = OAuthProvider(providerId: 'apple.com');
      final authCredential = oAuthProvider.getCredential(
          idToken: credential.identityToken,
          accessToken:credential.authorizationCode,
        );

      FirebaseUser userDetails =
          (await _firebaseAuth.signInWithCredential(authCredential)).user;

      this._name = userDetails.displayName == null ? "" : userDetails.displayName;
      this._email = userDetails.email;
      this._imageUrl = userDetails.photoUrl;
      this._uid = userDetails.uid;

      hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googlSignIn
        .signIn()
        .catchError((error) => print('error : $error'));
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        FirebaseUser userDetails =
            (await _firebaseAuth.signInWithCredential(credential)).user;

        this._name = userDetails.displayName;
        this._email = userDetails.email;
        this._imageUrl = userDetails.photoUrl;
        this._uid = userDetails.uid;

        hasError = false;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _errorCode = e.code;
        notifyListeners();
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  Future logInwithFacebook() async {
    FirebaseUser currentUser;
    // fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    // if you remove above comment then facebook login will take username and pasword for login in Webview

    final FacebookLoginResult facebookLoginResult = await fbLogin
        .logIn(['email', 'public_profile']).catchError(
            (error) => print('error: $error'));
    if (facebookLoginResult.status == FacebookLoginStatus.cancelledByUser) {
      _hasError = true;
      _errorCode = 'cancel';
      notifyListeners();
    } else if (facebookLoginResult.status == FacebookLoginStatus.error) {
      _hasError = true;
      notifyListeners();
    } else {
      try {
        if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
          FacebookAccessToken facebookAccessToken =
              facebookLoginResult.accessToken;
          final AuthCredential credential = FacebookAuthProvider.getCredential(
              accessToken: facebookAccessToken.token);
          final FirebaseUser user =
              (await _firebaseAuth.signInWithCredential(credential)).user;
          assert(user.email != null);
          assert(user.displayName != null);
          assert(!user.isAnonymous);
          assert(await user.getIdToken() != null);
          currentUser = await _firebaseAuth.currentUser();
          assert(user.uid == currentUser.uid);

          this._name = user.displayName;
          this._email = user.email;
          this._imageUrl = user.photoUrl;
          this._uid = user.uid;

          _hasError = false;
          notifyListeners();
        }
      } catch (e) {
        _hasError = true;
        _errorCode = e.code;
        notifyListeners();
      }
    }
  }

  Future signInWithEmailPassword(String email, String password) async {
    try {
      FirebaseUser userDetails = (await _firebaseAuth
              .signInWithEmailAndPassword(email: email, password: password))
          .user;
      this._uid = userDetails.uid;
      hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }

  Future registerWithEmailPassword(
      String email, String password, String name) async {
    try {
      FirebaseUser userDetails = (await _firebaseAuth
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;

      this._name = name;
      this._email = userDetails.email;
      this._imageUrl = userDetails.photoUrl;
      this._uid = userDetails.uid;

      hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.code;
      print(e.code);
      notifyListeners();
    }
  }

  Future checkUserExists() async {
    await Firestore.instance
        .collection('users')
        .getDocuments()
        .then((QuerySnapshot snap) {
      List values = snap.documents;
      List uids = [];
      values.forEach((element) {
        uids.add(element['uid']);
      });
      if (uids.contains(_uid)) {
        _userExists = true;
        print('User exists');
      } else {
        _userExists = false;
        print('new User');
      }
      notifyListeners();
    });
  }

  Future saveToFirebase() async {
    final DocumentReference ref =
        Firestore.instance.collection('users').document(uid);
    await ref.setData({
      'name': _name,
      'email': _email,
      'uid': _uid,
      'image url': _imageUrl,
      'joining date': _joiningDate,
      'loved blogs': [],
      'loved places': [],
      'bookmarked blogs': [],
      'bookmarked places': []
    });
  }

  Future getJoiningDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat('dd-MM-yyyy').format(now);
    _joiningDate = _date;
    notifyListeners();
  }

  Future saveDataToSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString('name', _name);
    await sharedPreferences.setString('email', _email);
    await sharedPreferences.setString('image url', _imageUrl);
    await sharedPreferences.setString('uid', _uid);
  }

  Future getUserData(uid) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot snap) {
      this._uid = snap.data['uid'];
      this._name = snap.data['name'];
      this._email = snap.data['email'];
      this._imageUrl = snap.data['image url'];
      this._joiningDate = snap.data['joining date'];
      print(_name);
    });
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('sign in', true);
    notifyListeners();
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('sign in') ?? false;
    notifyListeners();
  }
}

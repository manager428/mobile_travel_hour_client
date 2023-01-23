import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:travel_hour/blocs/internet_bloc.dart';
import 'package:travel_hour/blocs/sign_in_bloc.dart';
import 'package:travel_hour/pages/login.dart';
import 'package:travel_hour/pages/success.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/utils/snacbar.dart';
import 'package:travel_hour/utils/toast.dart';
import 'package:travel_hour/widgets/loading_signin_ui.dart';

class WellComePage extends StatefulWidget {
  WellComePage({Key key}) : super(key: key);

  _WellComePageState createState() => _WellComePageState();
}

class _WellComePageState extends State<WellComePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool signInStart = false;
  String brandName;

  void handleFacebbokLogin() async {
    final SignInBloc sb = Provider.of<SignInBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    await ib.checkInternet();
    if (ib.hasInternet == false) {
      openSnacbar(_scaffoldKey, 'No internet available');
    } else {
      setState(() {
        signInStart = true;
        brandName = 'facebbok';
      });

      await sb.logInwithFacebook().then((_) {
        if (sb.hasError == true) {
          openToast1(
              context, 'Error with facebook login! Please try with google');
          setState(() {
            signInStart = false;
          });
        } else {
          sb.checkUserExists().then((value) {
            if (sb.userExists == true) {
              sb.getUserData(sb.uid).then((value) => sb.saveDataToSP().then(
                  (value) => sb.setSignIn().then(
                      (value) => nextScreenReplace(context, SuccessPage()))));
            } else {
              sb.getJoiningDate().then((value) => sb.saveDataToSP().then(
                  (value) => sb.saveToFirebase().then((value) => sb
                      .setSignIn()
                      .then((value) =>
                          nextScreenReplace(context, SuccessPage())))));
            }
          });
        }
      });
    }
  }

  void handleGoogleLogin() async {
    final SignInBloc sb = Provider.of<SignInBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    await ib.checkInternet();
    if (ib.hasInternet == false) {
      openSnacbar(_scaffoldKey, 'No internet available');
    } else {
      setState(() {
        signInStart = true;
        brandName = 'google';
      });

      await sb.signInWithGoogle().then((_) {
        if (sb.hasError == true) {
          openToast1(context, 'Something is wrong. Please try again.');
          setState(() {
            signInStart = false;
          });
        } else {
          sb.checkUserExists().then((value) {
            if (sb.userExists == true) {
              sb.getUserData(sb.uid).then((value) => sb.saveDataToSP().then(
                  (value) => sb.setSignIn().then(
                      (value) => nextScreenReplace(context, SuccessPage()))));
            } else {
              sb.getJoiningDate().then((value) => sb.saveDataToSP().then(
                  (value) => sb.saveToFirebase().then((value) => sb
                      .setSignIn()
                      .then((value) =>
                          nextScreenReplace(context, SuccessPage())))));
            }
          });
        }
      });
    }
  }

  void handleAppleLogin() async {
    final SignInBloc sb = Provider.of<SignInBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    await ib.checkInternet();
    if (ib.hasInternet == false) {
      openSnacbar(_scaffoldKey, 'No internet available');
    } else {
      setState(() {
        signInStart = true;
        brandName = 'apple';
      });

      await sb.signInWithApple().then((_) {
        if (sb.hasError == true) {
          openToast1(context, 'Something is wrong. Please try again.');
          setState(() {
            signInStart = false;
          });
        } else {
          sb.checkUserExists().then((value) {
            if (sb.userExists == true) {
              sb.getUserData(sb.uid).then((value) => sb.saveDataToSP().then(
                  (value) => sb.setSignIn().then(
                      (value) => nextScreenReplace(context, SuccessPage()))));
            } else {
              sb.getJoiningDate().then((value) => sb.saveDataToSP().then(
                  (value) => sb.saveToFirebase().then((value) => sb
                      .setSignIn()
                      .then((value) =>
                          nextScreenReplace(context, SuccessPage())))));
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: signInStart == false ? welcomeUI() : loadingUI(brandName));
  }

  Widget welcomeUI() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              SizedBox(
                height: 130.0,
                child: Image.asset(
                  "assets/images/applogo.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  'Uncover Southern Idaho’s most beautiful views and epic adventures. Find directions to attractions & trails, reviews, photos, and nearby hotels & restaurants. Everything you need to start exploring!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
              ),
              Spacer(),
              Container(
                height: 44,
                width: w * 0.70,
                child: FlatButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  label: Text(
                    'Continue with google',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  color: Color(0xFFDB4A39),
                  onPressed: () {
                    handleGoogleLogin();
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 44,
                width: w * 0.70,
                child: FlatButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.facebook,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  label: Text(
                    'Continue with facebook',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  color: Colors.blueAccent,
                  onPressed: () {
                    handleFacebbokLogin();
                  },
                ),
              ),
              Platform.isIOS
                  ? (SizedBox(
                      height: 10,
                    ))
                  : (SizedBox(
                      height: 0,
                    )),
              Platform.isIOS
                  ? (Container(
                      width: w * 0.70,
                      child: SignInWithAppleButton(
                        borderRadius: BorderRadius.circular(25),
                        onPressed: () {
                          handleAppleLogin();
                        },
                      ),
                    ))
                  : (SizedBox(
                      height: 0,
                    )),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 45,
                width: w * 0.70,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  color: Colors.green,
                  onPressed: () {
                    nextScreen(context, SigninPage());
                  },
                ),
              ),
              SizedBox(
                height: h * 0.08,
              )
            ],
          ),
        ));
  }
}

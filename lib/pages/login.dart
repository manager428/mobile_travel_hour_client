import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/internet_bloc.dart';
import 'package:travel_hour/blocs/sign_in_bloc.dart';
import 'package:travel_hour/pages/signup.dart';
import 'package:travel_hour/pages/success.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/utils/snacbar.dart';
import 'package:travel_hour/utils/toast.dart';
import 'package:travel_hour/widgets/loading_signin_ui.dart';

class SigninPage extends StatefulWidget {
  SigninPage({Key key}) : super(key: key);

  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool signInStart = false;
  String brandName;

  String email;
  String password;
  void handleLogin() async {
    final SignInBloc sb = Provider.of<SignInBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    await ib.checkInternet();
    if (ib.hasInternet == false) {
      openSnacbar(_scaffoldKey, 'No internet available');
    } else {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();
        setState(() {
          signInStart = true;
          brandName = 'email and password';
        });
        await sb.signInWithEmailPassword(email, password).then((_) {
          if (sb.hasError == true) {
            openToast1(context, sb.errorCode);
            setState(() {
              signInStart = false;
            });
          } else {
            sb.checkUserExists().then((value) {
              if (sb.userExists == true) {
                sb.getUserData(sb.uid).then((value) => sb.saveDataToSP().then(
                    (value) => sb.setSignIn().then(
                        (value) => nextScreenReplace(context, SuccessPage()))));
              }
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: signInStart == false ? signinUI() : loadingUI(brandName));
  }

  Widget signinUI() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Hero(
                      tag: "back",
                      child: Container(
                        color: Colors.white,
                        child: Container(
                          height: 120,
                          width: w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 15,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(0.9),
                        child: IconButton(
                          icon: Icon(
                            LineIcons.arrow_left,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
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
                SizedBox(
                  height: 60,
                ),
                Container(
                    width: w * 0.70,
                    child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                              initialValue: email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                Pattern pattern =
                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(value))
                                  return 'Enter Valid Email';
                                else
                                  return null;
                              },
                              onChanged: (String value) {
                                setState(() {
                                  email = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Password",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0))),
                              initialValue: password,
                              obscureText: true,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.length == 0)
                                  return "Password can't be empty";
                                return null;
                              },
                              onChanged: (String value) {
                                setState(() {
                                  password = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ))),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 45,
                  width: w * 0.70,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      handleLogin();
                    },
                  ),
                ),
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
                      'Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                    color: Colors.blueAccent,
                    onPressed: () {
                      nextScreen(context, SignupPage());
                    },
                  ),
                ),
                SizedBox(
                  height: h * 0.15,
                )
              ],
            ),
          ),
        ));
  }
}

import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/widgets/navbar.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({Key key}) : super(key: key);

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 3000))
        .then((_) => nextScreenReplace(context, NavBar()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 150,
          width: 150,
          child: FlareActor(
            'assets/flr/success.flr',
            animation: 'success',
            alignment: Alignment.center,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

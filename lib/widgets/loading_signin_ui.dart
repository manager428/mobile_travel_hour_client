


import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

Widget loadingUI(String brandName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 180,
            width: 180,
            
            child: FlareActor(

              'assets/flr/load.flr',
              animation : 'load',
              //color: Colors.deepPurpleAccent,
              alignment: Alignment.center,
              fit: BoxFit.contain,

            
            
            
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'Signing with $brandName....',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[500]),
          )
        ],
      ),
    );
  }

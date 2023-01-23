import 'package:flutter/material.dart';

Widget emptyPage(icon, message) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Icon(
        icon,
        color: Colors.grey[500],
        size: 60,
      ),
      SizedBox(
        height: 10,
      ),
      Text(message,
          style: TextStyle(color: Colors.grey[500], fontSize: 18))
    ],
  );
}

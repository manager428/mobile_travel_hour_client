


import 'package:flutter/material.dart';

void openDialog (context, title, message){
  showDialog(
    context: context,
    
    builder: (BuildContext context){
      return AlertDialog(
        content: Text(message),
        title: Text(title),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('OK'))
        ],

      );
    }
    
    );
}
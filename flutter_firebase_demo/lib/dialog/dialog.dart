import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/general/message_type.dart';

showMessageDialog(
    {BuildContext context, String title, String message, MessageType type}) {
  Color color = Colors.greenAccent;

  if (type == MessageType.warning) {
    color = Colors.redAccent;
  } else if (type == MessageType.error) {
    color = Colors.red;
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: TextStyle(color: color)),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

showCircularProgressBar(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      });
}

showLinearProgressBar(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return LinearProgressIndicator();
      });
}

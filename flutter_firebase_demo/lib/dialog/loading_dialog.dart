import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  LoadingDialogState state;

  bool isShowing() {
    return state != null && state.mounted;
  }

  @override
  createState() => state = LoadingDialogState();
}

class LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
      ),
    );
  }
}

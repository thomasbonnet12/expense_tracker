import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  final String buttonText;
  final Function buttonFunction;

  const AdaptiveButton(
      @required this.buttonText, @required this.buttonFunction);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child:
                Text(buttonText, style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: buttonFunction,
          )
        : FlatButton(
            textColor: Theme.of(context).primaryColor,
            onPressed: buttonFunction,
            child: Text(
              buttonText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}

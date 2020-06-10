import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/utility/my_style.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(
        message,
        style: kLabelStyleblack,
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK', style: kLabelStyleblack)),
          ],
        )
      ],
    ),
  );
}

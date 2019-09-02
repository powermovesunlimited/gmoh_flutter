import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitledDivider extends StatelessWidget {
  final String _title;

  TitledDivider(this._title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Divider(),
          ),
        ),
        Text(_title),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Divider(),
          ),
        )
      ],
    );
  }
}

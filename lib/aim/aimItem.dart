
import 'package:flutter/material.dart';
class AimItem extends StatelessWidget {
  AimItem({this.aimMain, this.aimText,this.index});
  final String aimMain;
  final String aimText;
  final String index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Text(index),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  aimMain,
                  style: Theme.of(context).textTheme.subhead,
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(aimText, style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
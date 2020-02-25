import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_aim.dart';

class AimListPage extends StatefulWidget {
  @override
  _AimListPageState createState() => _AimListPageState();
}

class _AimListPageState extends State<AimListPage> {
  final List<AimItem> _aimItemList = <AimItem>[];

  @override
  void initState() {
    super.initState();
    getAimList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("目标清单"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              //new
              padding: new EdgeInsets.all(8.0), //new
              reverse: false, //new
              itemBuilder: (_, int index) => _aimItemList[index], //new
              itemCount: _aimItemList.length,
              //new
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddAim(context, _aimItemList.length);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> getAimList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _aimItemList.clear();
    int i = 1;
    while (preferences.getString(i.toString() + "Aim") != null) {
      Map aimMap = jsonDecode(preferences.getString(i.toString() + "Aim"));
      if (aimMap != null) {
        AimItem aim = AimItem(
          index: i.toString(),
          aimMain: aimMap["aimTitle"],
          aimText: aimMap["content"],
        );
        _aimItemList.add(aim);
        i++;
      }
    }
    setState(() {});
  }

  void _navigateToAddAim(BuildContext context, int length) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddAimPage(length)));
    if (result == "OK") {
      getAimList();
    }
  }
}

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

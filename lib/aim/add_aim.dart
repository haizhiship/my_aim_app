import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aim.dart';


// ignore: must_be_immutable
class AddAimPage extends StatelessWidget {
  TextEditingController _newAimTitleController = new TextEditingController();
  TextEditingController __newAimContentController = new TextEditingController();
  GlobalKey _addNewAimKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('录入目标'),
      ),
      body: Form(
        key: _addNewAimKey,
        child: ListView(
          padding: EdgeInsets.all(35),
          children: <Widget>[
            _newAimPageTitle(),
            _initHorizontalLine(),
            _addAimTitle(),
            _addAimContext(),
            _addAimBtn(context),
          ],
        ),
      ),
    );
  }

  Padding _newAimPageTitle() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        '我的新目标',
        style: TextStyle(
            fontSize: 25.0,
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Padding _initHorizontalLine() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.deepOrange,
            width: 100,
            height: 2,
          ),
        ));
  }

  TextFormField _addAimTitle() {
    return TextFormField(
      controller: _newAimTitleController,
      maxLength: 15,
      decoration: InputDecoration(labelText: '目标名称', icon: Icon(Icons.mood)),
      validator: (String value) {
        return value.isEmpty ? "目标名称不能为空" : null;
      },
    );
  }

  TextFormField _addAimContext() {
    return TextFormField(
      controller: __newAimContentController,
      maxLength: 600,
      maxLines: 6,
      decoration:
      InputDecoration(labelText: '目标内容', icon: Icon(Icons.assignment)),
      validator: (String value) {
        return value.isEmpty ? "目标内容不能为空" : null;
      },
    );
  }

  Padding _addAimBtn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              padding: EdgeInsets.all(15),
              child: Text('保存'),
              color: Theme
                  .of(context)
                  .primaryColor,
              textColor: Colors.white,
              onPressed: () {
                if ((_addNewAimKey.currentState as FormState).validate()) {
                  Aim aim = new Aim(_newAimTitleController.text,
                      __newAimContentController.text);
                  _saveAim(aim);
                  Navigator.pop(context,true);
                }
              },
            ),
          )
        ],
      ),
    );
  }


  void _saveAim(Aim aim) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String aimStr = jsonEncode(aim);
    preferences.setString("111", aimStr);
    Map aimMap = jsonDecode(preferences.getString("111"));
    print(aimMap["content"]);
  }
}
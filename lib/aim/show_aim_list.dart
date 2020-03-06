import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_aim.dart';
import 'aim.dart';
import 'show_aim_detail.dart';

class AimListPage extends StatefulWidget {
  @override
  _AimListPageState createState() => _AimListPageState();
}

class _AimListPageState extends State<AimListPage> {
  final List<Aim> _aimItemList = <Aim>[];
  int totalAimCount; //用于保存所有的目标数量，包括生效和删除的。每次新增目标在此基础上。
  SlidableController slidableController;

  @override
  void initState() {
    getAimList();
    super.initState();
    //getAimList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("目标清单"),
      ),
      body: Center(
        child: OrientationBuilder(
          builder: (context, orientation) => _buildListView(
              context,
              orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddAim(context, totalAimCount);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> getAimList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _aimItemList.clear();
    totalAimCount = 0;
    int i = 1;
    while (preferences.getString(i.toString() + "Aim") != null) {
      Map aimMap = jsonDecode(preferences.getString(i.toString() + "Aim"));
      if (aimMap != null && aimMap["valid"] == "1") {
        Aim aim = Aim(i.toString(), aimMap["aimTitle"], aimMap["content"], "1");
        _aimItemList.add(aim);
      }
      i++;
    }
    totalAimCount = i - 1;
    setState(() {});
  }

  void _navigateToAddAim(BuildContext context, int length) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            //如果为新增则length为最大长度，传空值用于新，否则传待修改值
            builder: (context) => NewAimPage(
                length,
                totalAimCount == length ? "" : _aimItemList[length].getTitle,
                totalAimCount == length
                    ? ""
                    : _aimItemList[length].getContent)));
    if (result == "OK") {
      getAimList();
    }
  }

  void _navigateToModifyAim(BuildContext context, int index) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewAimPage(
                int.parse(_aimItemList[index].getIndex) - 1,
                _aimItemList[index].getTitle,
                _aimItemList[index].getContent)));
    if (result == "OK") {
      getAimList();
    }
  }

  Widget _buildListView(BuildContext context, Axis direction) {
    return ListView.separated(
      scrollDirection: direction,
      itemBuilder: (context, index) {
        final Axis slidableDirection =
            direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
        return _getSlidableWithLists(context, index, slidableDirection);
      },
      itemCount: _aimItemList.length,
      separatorBuilder: (context, index) {
        return Divider(
          height: 2.0,
          indent: 0.0,
        );
      },
    );
  }

  Widget _getSlidableWithLists(
      BuildContext context, int index, Axis direction) {
    final Aim item = _aimItemList[index];
    //final int t = index;
    return Slidable(
      key: Key(item.getIndex),
      controller: slidableController,
      direction: direction,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          _showSnackBar(
              context,
              actionType == SlideActionType.primary
                  ? 'Dismiss Archive'
                  : 'Dimiss Delete');
          setState(() {
            _aimItemList.removeAt(index);
          });
        },
      ),
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      child: direction == Axis.horizontal
          ? VerticalListItem(_aimItemList[index], index)
          : HorizontalListItem(_aimItemList[index]),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => _showSnackBar(context, 'Archive'),
        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => _showSnackBar(context, 'Share'),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '修改',
          color: Colors.green,
          icon: Icons.mode_edit,
          onTap: () => _modifyItem(_aimItemList[index], index),
          closeOnTap: false,
        ),
        IconSlideAction(
          caption: '删除',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteItem(_aimItemList[index], index),
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _deleteItem(Aim aim, int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    aim.setValid = '0';
    String aimStr = jsonEncode(aim);
    preferences.setString((aim.getIndex).toString() + "Aim", aimStr);
    getAimList();
  }

  void _modifyItem(Aim aimItemList, int index) {
    _navigateToModifyAim(context, index);
  }
}

class HorizontalListItem extends StatelessWidget {
  HorizontalListItem(this.item);
  final Aim item;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 160.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: CircleAvatar(
              //backgroundColor: ,
              child: Text('${item.getIndex}'),
              foregroundColor: Colors.white,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                item.getContent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalListItem extends StatelessWidget {
  VerticalListItem(this.item, this.index);
  final Aim item;
  final int index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToAimDetail(context),
      child: Container(
        color: Colors.white,
        child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text((index + 1).toString()),
              foregroundColor: Colors.white,
            ),
            title: Text(item.getTitle),
            subtitle: Text(item.getContent),
            trailing: Icon(Icons.chevron_right)),
      ),
    );
  }

  _navigateToAimDetail(BuildContext context) {
    final result = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AimDetailPage(),
      ),
    );
  }
}

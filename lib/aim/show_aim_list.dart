import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'add_aim.dart';
import 'aim.dart';
import 'aimItem.dart';

class AimListPage extends StatefulWidget {
  @override
  _AimListPageState createState() => _AimListPageState();
}

class _AimListPageState extends State<AimListPage> {
  final List<Aim> _aimItemList = <Aim>[];
  SlidableController slidableController;

  @override
  void initState() {
    super.initState();
    //getAimList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("目标清单"),
      ),
      body:  Center(
        child: OrientationBuilder(
          builder: (context, orientation) =>
              _buildListView(
                  context,
                  orientation == Orientation.portrait
                      ? Axis.vertical
                      : Axis.horizontal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddAim(context, _aimItemList.length);
          print("bb114");
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
      if (aimMap != null && aimMap["valid"] == "1") {
        Aim aim = Aim(i.toString(),aimMap["aimTitle"],aimMap["content"],"1");
        _aimItemList.add(aim);
      }
      i++;
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

  Widget _buildListView(BuildContext context, Axis direction) {
    return ListView.builder(
      scrollDirection: direction,
      itemBuilder: (context, index) {
        final Axis slidableDirection =
        direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
        var item = _aimItemList[index];
        return _getSlidableWithLists(context, index, slidableDirection);
      },
      itemCount: _aimItemList.length,
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
          ? VerticalListItem(_aimItemList[index])
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
        Container(
          height: 800,
          color: Colors.green,
          child: Text('a'),
        ),
        IconSlideAction(
          caption: 'More',
          color: Colors.grey.shade200,
          icon: Icons.more_horiz,
          onTap: () => _showSnackBar(context, 'More'),
          closeOnTap: false,
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _showSnackBar(context, 'Delete'),
        ),
      ],
    );
  }


  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
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
  VerticalListItem(this.item);

  final Aim item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
      Slidable
          .of(context)
          ?.renderingMode == SlidableRenderingMode.none
          ? Slidable.of(context)?.open()
          : Slidable.of(context)?.close(),
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('${item.getIndex}'),
            foregroundColor: Colors.white,
          ),
          title: Text(item.getTitle),
          subtitle: Text(item.getContent),
        ),
      ),
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class AimDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AimDetail(title: '目标详单'),
    );
  }
}

class AimDetail extends StatefulWidget {
  AimDetail({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAimDetailState createState() => new _MyAimDetailState();
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

class _MyAimDetailState extends State<AimDetail> {
  int _counter = 4;

  final serialdata = [
    new TimeSeriesSales(new DateTime(2017, 9, 1), 5),
    new TimeSeriesSales(new DateTime(2017, 9, 2), 25),
    new TimeSeriesSales(new DateTime(2017, 9, 3), 100),
    new TimeSeriesSales(new DateTime(2017, 9, 4), 75),
  ];
  Random random = new Random();

  void _incrementCounter() {
    setState(() {
      _counter++;
      serialdata.add(new TimeSeriesSales(
          new DateTime(2017, 9, _counter), random.nextInt(100)));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<TimeSeriesSales, DateTime>> seriesList = [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: serialdata,
      )
    ];

    var chart = new charts.TimeSeriesChart(
      seriesList,
      animate: true,
    );
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, "OK");
          },
        ),
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            chartWidget,
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}

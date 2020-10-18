import 'package:flutter/material.dart';
import 'package:flutter_http_monitor/gen_monitor.dart';
import 'package:flutter_http_monitor/monitor_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GENMonitorProvider monitorProvider = GENMonitorProvider();
  GENData monitorData = GENData(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: MonitorView(
          data: monitorData,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("Pressed!");
          monitorProvider.signIn(GENCredentials('USERID', 'PASS'));
          final GENData newData = await monitorProvider.poll();
          if (newData != monitorData) {
            print("Data has changed!");
            setState(() => monitorData = newData);
          }
        },
      ),
    );
  }
}

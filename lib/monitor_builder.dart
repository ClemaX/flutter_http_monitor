import 'package:flutter/widgets.dart';
import 'package:flutter_http_monitor/monitor_provider.dart';

class MonitorView extends StatelessWidget {
  final MonitorData data;

  const MonitorView({Key key, this.data}) : super(key: key);

  MonitorWidget _mapDataToWidgets(MonitorValue elem) {
    return MonitorLabel(data: elem.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: data.props.map(_mapDataToWidgets).toList(growable: false),
    );
  }
}

abstract class MonitorWidget extends StatelessWidget {
  final dynamic data;

  const MonitorWidget({Key key, this.data});
}

class MonitorLabel extends MonitorWidget {
  final String data;

  const MonitorLabel({Key key, this.data});

  @override
  Widget build(BuildContext context) {
    return Text(data);
  }
}

import 'package:flutter_http_monitor/monitor_provider.dart';
import 'package:flutter_http_monitor/session_monitor_provider.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class GENCredentials extends MonitorCredentials {
  final String id;
  final String password;
  final String action;

  const GENCredentials(this.id, this.password, [this.action = "Envoyer"])
      : super();

  @override
  Map<String, String> get asMap => {
        'identifiant': id,
        'codeConnexion': password,
        'action': action,
      };
}

class GENMonitorProvider extends SessionMonitorProvider {
  @override
  Future<GENData> poll() async {
    final http.Response response =
        await get('https://dse.orion.education.fr/suiviGEN/notif?rqRang=0');

    final doc = parse(response.body);
    final tbodies = doc.getElementsByTagName('tbody');
    return GENData(tbodies.isNotEmpty ? tbodies[0].children.length - 1 : 0);
  }

  @override
  Future<http.Response> signIn(MonitorCredentials credentials) {
    return post(
      'https://dse.orion.education.fr/suiviGEN/accueil',
      body: credentials.asMap,
    );
  }

  @override
  Future<http.Response> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}

class GENData extends MonitorData {
  final MonitorValue<int> transactionCount;

  GENData(
    int transactionCount,
  ) : this.transactionCount =
            MonitorValue<int>("Transaction Count", transactionCount);

  @override
  List<MonitorValue> get props => [transactionCount];
}

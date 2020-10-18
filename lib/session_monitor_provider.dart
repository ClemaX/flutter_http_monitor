import 'dart:convert';

import 'package:flutter_http_monitor/cookies.dart';
import 'package:flutter_http_monitor/monitor_provider.dart';
import 'package:http/http.dart' as http;

abstract class SessionMonitorException implements Exception {
  /// A text description of the `Exception`.
  String get message;

  const SessionMonitorException();
}

class SessionMonitorHTTPException extends SessionMonitorException {
  final http.Response response;
  const SessionMonitorHTTPException(this.response);

  @override
  String get message =>
      "Error on '${response.request.method}' request to ${response.request.url}: ${response.statusCode}";
}

abstract class SessionMonitorProvider extends MonitorProvider {
  Map<String, String> headers = Map<String, String>();
  Cookies cookies = Cookies();

  void handleResponse(http.Response response) {
    final String body = response.body;
    final int statusCode = response.statusCode;

    if (cookies.parseResponse(response)) headers['cookie'] = cookies.toHeader();

    if (statusCode < 200 || statusCode > 400 || body == null)
      throw SessionMonitorHTTPException(response);
  }

  Future<http.Response> get(String url) async {
    final http.Response response = await http.get(url, headers: headers);

    handleResponse(response);
    return response;
  }

  Future<http.Response> post(String url,
      {Map<String, String> body, Encoding encoding}) async {
    final http.Response response = await http.post(
      url,
      headers: headers,
      encoding: encoding,
      body: body,
    );

    handleResponse(response);
    return response;
  }
}

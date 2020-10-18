import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

abstract class MonitorProvider {
  /// Sign in using `MonitorCredentials`.
  Future<http.Response> signIn(MonitorCredentials credentials);

  /// Poll the server.
  ///
  /// Returns `MonitorData`.
  Future<MonitorData> poll();

  /// Sign out.
  Future<http.Response> signOut();
}

abstract class MonitorCredentials extends Equatable {
  Map<String, String> get asMap;

  const MonitorCredentials() : super();

  @override
  List<Object> get props => [asMap];
}

class MonitorValue<T> extends Equatable {
  final String label;
  final T value;

  const MonitorValue(this.label, [this.value]);

  @override
  String toString() => "$label: ${value.toString()}";

  @override
  List<Object> get props => [label, value];
}

abstract class MonitorData extends Equatable {
  const MonitorData() : super();

  @override
  List<MonitorValue> get props => [];
}

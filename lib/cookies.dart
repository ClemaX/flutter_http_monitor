import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

class Cookies extends MapBase<String, CookieData> {
  final Map<String, CookieData> _map;

  Cookies() : this._map = Map<String, CookieData>();

  @override
  CookieData operator [](Object key) => _map[key];

  @override
  void operator []=(String key, CookieData value) => _map[key] = value;

  @override
  void clear() => _map.clear();

  @override
  Iterable<String> get keys => _map.keys;

  @override
  CookieData remove(Object key) => _map.remove(key);

  /// Parse `CookieData` from a `Set-Cookie` header.
  CookieData setCookie(String setCookie) {
    List<String> setCookieParts = setCookie.split(';');

    String cookieKey;
    String cookieValue;
    DateTime cookieExpires;
    String cookiePath;
    bool cookieHttpOnly = false;
    bool cookieSecure = false;

    for (String part in setCookieParts) {
      final List<String> cookieData = part.split('=');

      if (cookieData.isNotEmpty) {
        final String key = cookieData[0].trim();
        final String value = cookieData.length > 1 ? cookieData[1] : '';

        if (key == 'path')
          cookiePath = value;
        else if (key == 'expires')
          cookieExpires = DateTime.parse(value);
        else if (key == 'HttpOnly')
          cookieHttpOnly = true;
        else if (key == 'Secure')
          cookieSecure = true;
        else if (key.isNotEmpty && value.isNotEmpty) {
          cookieKey = key;
          cookieValue = value;
        }
      }
    }

    return _map[cookieKey] = CookieData(
      cookieValue,
      cookieExpires,
      cookiePath,
      cookieHttpOnly,
      cookieSecure,
    );
  }

  /// Parse a HTTP `Response`'s cookies.
  ///
  /// Returns `true` when cookies have been updated.
  /// Returns `false` otherwise.
  bool parseResponse(http.Response response) {
    final setCookieHeaders = response.headers['set-cookie'];

    if (setCookieHeaders != null) {
      final List<String> setCookies = setCookieHeaders.split(',');

      setCookies.forEach(setCookie);
      return setCookies.isNotEmpty;
    }
    return false;
  }

  /// Get the cookie header.
  String toHeader() {
    String cookie = "";

    _map.forEach((key, value) {
      if (cookie.length > 0) cookie += ';';
      cookie += '$key=$value';
    });
    return cookie;
  }
}

class CookieData extends Equatable {
  final String value;
  final DateTime expires;
  final String path;
  final bool httpOnly;
  final bool secure;

  const CookieData(
    this.value, [
    this.expires,
    this.path,
    this.httpOnly = false,
    this.secure = false,
  ])  : assert(value != null, "A cookie's value cannot be null!"),
        super();

  @override
  String toString() => value;

  @override
  List<Object> get props => [
        value,
        expires,
        path,
        httpOnly,
        secure,
      ];
}

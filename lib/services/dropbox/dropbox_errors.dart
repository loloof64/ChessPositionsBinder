import 'dart:convert';

abstract class RequestError {
  abstract final dynamic body;
  abstract final String? message;
  abstract final String className;

  @override
  String toString() {
    return "$className()\n${body ?? ''}";
  }
}

class ExpiredCredentials extends RequestError {
  final dynamic _body;

  ExpiredCredentials(this._body);

  @override
  String? get message => null;

  @override
  get body => _body;

  @override
  String get className => "ExpiredCredentials";
}

class NoClientAvailable extends RequestError {
  final dynamic _body;

  NoClientAvailable(this._body);

  @override
  String? get message => null;

  @override
  get body => _body;

  @override
  String get className => "NoClientAvailable";
}

class NotATextFile extends RequestError {
  final dynamic _body;

  NotATextFile(this._body);

  @override
  String? get message => null;

  @override
  get body => _body;

  @override
  String get className => "NotATextFile";
}

class BadInput extends RequestError {
  final dynamic _body;
  final String _message;

  BadInput(this._body, this._message);

  @override
  String get message => _message;

  @override
  get body => _body;

  @override
  String get className => "BadInput";
}

class AuthError extends RequestError {
  final dynamic _body;
  final String _message;

  AuthError(this._body, this._message);

  @override
  String get message => _message;

  @override
  get body => _body;

  @override
  String get className => "AuthError";
}

class NoPermissionError extends RequestError {
  final dynamic _body;

  NoPermissionError(this._body);

  @override
  String? get message => null;

  @override
  get body => _body;

  @override
  String get className => "NoPermissionError";
}

class EndpointError extends RequestError {
  final dynamic _body;

  EndpointError(this._body);

  @override
  String? get message => null;

  @override
  get body => _body;

  @override
  String get className => "EndpointError";
}

class RateLimitError extends RequestError {
  final dynamic _body;

  RateLimitError(this._body);

  @override
  String? get message => null;

  @override
  get body => _body;

  @override
  String get className => "RateLimitError";
}

class ServerError extends RequestError {
  final dynamic _body;

  ServerError(this._body);

  @override
  String? get message => null;

  @override
  get body => _body;

  @override
  String get className => "ServerError";
}

class UnknownError extends RequestError {
  final dynamic _body;

  UnknownError(this._body);

  @override
  String? get message => null;

  @override
  get body => _body;

  @override
  String get className => "UnknownError";
}

RequestError convertError(int statusCode, responseBody) {
  final bodyAsMap = jsonDecode(responseBody);
  return switch (statusCode) {
    400 => BadInput(bodyAsMap, bodyAsMap["error_summary"]),
    401 => AuthError(bodyAsMap, bodyAsMap["error_summary"]),
    403 => NoPermissionError(bodyAsMap),
    409 => EndpointError(bodyAsMap),
    429 => RateLimitError(bodyAsMap),
    >= 500 && < 600 => ServerError(bodyAsMap),
    _ => UnknownError(bodyAsMap),
  };
}

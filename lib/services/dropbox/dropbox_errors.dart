import 'dart:convert';

abstract class RequestError {
  abstract final String? message;
}

class ExpiredCredentials extends RequestError {
  @override
  String? get message => null;
}

class NoClientAvailable extends RequestError {
  @override
  String? get message => null;
}

class NotATextFile extends RequestError {
  @override
  String? get message => null;
}

class BadInput extends RequestError {
  final String _message;

  BadInput(this._message);

  @override
  String get message => _message;
}

class AuthError extends RequestError {
  final String _message;

  AuthError(this._message);

  @override
  String get message => _message;
}

class NoPermissionError extends RequestError {
  @override
  String? get message => null;
}

class EndpointError extends RequestError {
  @override
  String? get message => null;
}

class RateLimitError extends RequestError {
  @override
  String? get message => null;
}

class ServerError extends RequestError {
  @override
  String? get message => null;
}

class UnknownError extends RequestError {
  @override
  String? get message => null;
}

RequestError convertError(int statusCode, responseBody) {
  final bodyAsMap = jsonDecode(responseBody);
  return switch (statusCode) {
    400 => BadInput(bodyAsMap["error_summary"]),
    401 => AuthError(bodyAsMap["error_summary"]),
    403 => NoPermissionError(),
    409 => EndpointError(),
    429 => RateLimitError(),
    >= 500 && < 600 => ServerError(),
    _ => UnknownError(),
  };
}

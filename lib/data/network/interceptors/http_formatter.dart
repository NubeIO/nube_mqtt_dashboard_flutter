import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../utils/logger/log.dart';

typedef HttpLoggerFilter = bool Function();
const String _tag = "HttpFormatter";

class HttpFormatter extends Interceptor {
  // Logger object to pretty print the HTTP Request
  static const List<String> defaultHeaders = [
    "content-length",
    "access-control-allow-origin",
    "Authentication"
  ];
  final bool _includeRequest,
      _includeRequestHeaders,
      _includeRequestBody,
      _includeResponse,
      _includeResponseHeaders,
      _includeResponseBody,
      _filterHeaders;

  final List<String> _includeHeaders;

  /// Optionally add a filter that will log if the function returns true
  final HttpLoggerFilter _httpLoggerFilter;

  /// Optionally can add custom [LogPrinter]
  HttpFormatter(
      {bool includeRequest = true,
      bool includeRequestHeaders = true,
      bool includeRequestBody = true,
      bool includeResponse = true,
      bool includeResponseHeaders = true,
      bool includeResponseBody = true,
      bool filterHeaders = true,
      List<String> includeHeaders = defaultHeaders,
      HttpLoggerFilter httpLoggerFilter})
      : _includeRequest = includeRequest,
        _includeRequestHeaders = includeRequestHeaders,
        _includeRequestBody = includeRequestBody,
        _includeResponse = includeResponse,
        _includeResponseHeaders = includeResponseHeaders,
        _includeResponseBody = includeResponseBody,
        _filterHeaders = filterHeaders,
        _includeHeaders = includeHeaders ?? [],
        _httpLoggerFilter = httpLoggerFilter;

  String filterHeaders(
    MapEntry<String, dynamic> header,
    String responseString,
  ) {
    String output = responseString;
    if (_filterHeaders) {
      if (_includeHeaders.contains(header.key)) {
        output += '${header.key}: ${header.value}\n';
      }
    } else {
      output += '${header.key}: ${header.value}\n';
    }
    return output;
  }

  @override
  Future onError(DioError err) {
    if (_httpLoggerFilter == null || _httpLoggerFilter()) {
      final message = _prepareLog(err.request, err.response);
      if (message != null && message != '') {
        Log.e(message, tag: _tag);
      }
    }
    return super.onError(err);
  }

  @override
  Future onRequest(RequestOptions options) {
    options.extra = <String, dynamic>{
      'start_time': DateTime.now().millisecondsSinceEpoch
    };
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    if (_httpLoggerFilter == null || _httpLoggerFilter()) {
      final message = _prepareLog(response.request, response);
      if (message != null && message != '') {
        Log.i(message);
      }
    }
    return super.onResponse(response);
  }

  /// Whether to pretty print a JSON or return as regular String
  String _getBody(dynamic data, String contentType) {
    if (data is Map<String, dynamic> && data.isEmpty) {
      return "";
    } else if (data is String && data.isEmpty) {
      return "";
    }
    if (contentType != null &&
        contentType.toLowerCase().contains('application/json')) {
      const encoder = JsonEncoder.withIndent('  ');
      dynamic jsonBody;
      if (data is String) {
        jsonBody = jsonDecode(data);
      } else {
        jsonBody = data;
      }
      return encoder.convert(jsonDecode(jsonEncode(jsonBody)));
    } else {
      return data.toString();
    }
  }

  /// Extracts the headers and body (if any) from the request and response
  String _prepareLog(RequestOptions requestOptions, Response response) {
    var requestString = '', responseString = '';

    if (_includeRequest) {
      requestString = '⤴ REQUEST ⤴\n\n';

      requestString += '${requestOptions.method} ${requestOptions.uri}\n';

      if (_includeRequestHeaders) {
        for (final header in requestOptions.headers.entries) {
          responseString = filterHeaders(header, responseString);
        }
      }

      if (_includeRequestBody && requestOptions.data != null) {
        requestString +=
            '\n\n${_getBody(requestOptions.data, requestOptions.contentType)}';
      }

      requestString += '\n\n';
    }

    if (_includeResponse && response != null) {
      responseString =
          '⤵ RESPONSE [${response.statusCode}/${response.statusMessage}] '
          '${requestOptions.extra['start_time'] != null ? '[Time elapsed: ${DateTime.now().millisecondsSinceEpoch - int.parse(requestOptions.extra['start_time'].toString())} ms]' : ''}'
          '⤵\n\n';

      if (_includeResponseHeaders) {
        for (final header in response.headers.map.entries) {
          responseString = filterHeaders(header, responseString);
        }
      }

      if (_includeResponseBody && response.data != null) {
        responseString +=
            '\n\n${_getBody(response.data, response.headers.value('content-type'))}';
      }
    }

    return requestString + responseString;
  }
}

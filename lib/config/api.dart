import 'dart:convert';

import 'package:http/http.dart' as http;

Future<dynamic> httpRequestGet(
    String pathname, Map<String, String> query) async {
  Uri uri = Uri.https('api.unsplash.com', pathname,
      {'client_id': 'IPwdJhKYi445Ry5SjGDP6Qc4yXjq1TJyDS_vejzuLBA', ...query});
  var response = await http.get(uri);
  dynamic body = jsonDecode(response.body);
  return body;
}

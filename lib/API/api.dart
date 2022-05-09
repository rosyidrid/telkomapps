import 'dart:convert';

import 'package:http/http.dart' as http;

class CallAPI {
  final String url = 'http://testdev.playbooksf.com/api/';

  _setHeadersLogin() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _setHeaders(data) =>
      {'Content-type': 'application/json', 'Authorization': 'Bearer $data'};

  _setHeaderUpload(data) => {
        'Content-type': 'application/form-data',
        'Accept': 'application/form-data',
        'Authorization': 'Bearer $data'
      };

  login(data, apiURL) async {
    var fullUrl = url + apiURL;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeadersLogin());
  }

  getDataUser(data, apiURL) async {
    var fullUrl = url + apiURL;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders(data));
  }

  logout(data, apiURL) async {
    var fullUrl = url + apiURL;
    return await http.delete(Uri.parse(fullUrl), headers: _setHeaders(data));
  }

  selfie(token, apiURL, data) async {
    var fullUrl = url + apiURL;
    return await http.post(Uri.parse(fullUrl),body: data, headers: _setHeaderUpload(token));
  }
}

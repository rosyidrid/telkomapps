import 'dart:convert';

import 'package:http/http.dart' as http;

class CallAPI {
  final String url = 'http://testdev.playbooksf.com/api/';
  postData(data, apiURL) async {
    var fullUrl = url + apiURL;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeadersLogin());
  }

  _setHeadersLogin() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  getDataUser(data, apiURL) async {
    var fullUrl = url + apiURL;
    return await http.get(Uri.parse(fullUrl), headers: _setHeadersUser(data));
  }

  _setHeadersUser(data) =>
      {'Content-type': 'application/json', 'Authorization': 'Bearer $data'};

  logout(data, apiURL) async {
    var fullUrl = url + apiURL;
    return await http.delete(Uri.parse(fullUrl),
        headers: _setHeaderLogout(data));
  }

  _setHeaderLogout(data) => {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $data',
      };
}

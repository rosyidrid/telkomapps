import 'dart:convert';
import 'package:http/http.dart' as http;

class CallAPI {
  final String url = 'http://testdev.playbooksf.com/api/';

  _setHeadersLogin() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _setHeaders(token) =>
      {'Content-type': 'application/json', 'Authorization': 'Bearer $token'};

  _setHeaderUpload(data) =>
      {'Content-type': 'multipart/form-data', 'Authorization': 'Bearer $data'};

  login(data, apiURL) async {
    var fullUrl = url + apiURL;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeadersLogin());
  }

  getDataUser(token, apiURL) async {
    var fullUrl = url + apiURL;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders(token));
  }

  getDataOutletPJP(token, apiURL) async {
    var fullUrl = url + apiURL;
    return await http.get(Uri.parse(fullUrl), headers: _setHeaders(token));
  }

  logout(token, apiURL) async {
    var fullUrl = url + apiURL;
    return await http.delete(Uri.parse(fullUrl), headers: _setHeaders(token));
  }

  checkin(token, apiURL, data) async {
    var fullUrl = url + apiURL;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders(token));
  }

  checkout(token, apiURL, data) async {
    var fullUrl = url + apiURL;
    return await http.put(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders(token));
  }

  upload(token, apiURL, data, photo) async {
    var fullUrl = url + apiURL;
    var request = http.MultipartRequest('POST', Uri.parse(fullUrl));
    request.headers.addAll(_setHeaderUpload(token));
    request.fields['checkin_id'] = data['checkin_id'].toString();
    request.files.add(await http.MultipartFile.fromPath(
        'photo_' + photo, data['photo_' + photo]));
    http.Response response =
        await http.Response.fromStream(await request.send());
    return response;
  }
}

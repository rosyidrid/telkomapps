import 'package:flutter/material.dart';
import 'package:telkom_apps/dashboard/dashboard.dart';
import 'package:telkom_apps/API/api.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FormPage extends StatefulWidget {
  const FormPage({
    Key? key,
  }) : super(key: key);
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool pass = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              width: size.width * 0.8,
              child: Text(
                "Login",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    color: Color(0xFFFF4949)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 25),
              width: size.width * 0.8,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 3,
                    offset: Offset(1, 1),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, color: Color(0xFFFF4949)),
                      hintText: "Username",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 5,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 5,
                    thickness: 1,
                    indent: 5,
                    endIndent: 10,
                  ),
                  TextFormField(
                    controller: password,
                    obscureText: pass,
                    decoration: InputDecoration(
                      icon: Icon(Icons.key, color: Color(0xFFFF4949)),
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              pass = !pass;
                            });
                          },
                          child: pass == true
                              ? Icon(Icons.visibility_off, color: Colors.grey)
                              : Icon(Icons.visibility,
                                  color: Color(0xFFFF4949))),
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _doLogin();
              },
              child: Text(
                "LOGIN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * 0.8, 40),
                  primary: Color(0xFFFF4949),
                  textStyle: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ));
  }

  Future<void> _doLogin() async {
    // var[array] data
    var userLogin = {
      'username': username.text,
      'password': password.text,
      'device_name': "Android",
    };

    final prefs = await SharedPreferences.getInstance();
    var resLogin = await CallAPI().postData(userLogin, 'login');
    var bodyLogin = json.decode(resLogin.body);
    //cek apakah login berhasil
    if (resLogin.statusCode == 200) {
      //jika iya maka
      //data username dan token akan di simpan di localstorage
      prefs.setString('token', bodyLogin['data']['token']);
      var token = prefs.get("token");
      var dataUser = await CallAPI().getDataUser(token, 'user');
      var bodyUser = json.decode(dataUser.body);
      prefs.setString('user', json.encode(bodyUser['data']));
      //setelah di simpen di localstorage
      //page berganti kehalaman dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return Dashboard();
        }),
      );
    } else {
      //jika gagal
      //akan memuncul kan pop up message
      var message = bodyLogin['message'];
      Widget okButton = TextButton(
        child: Text("Close"),
        onPressed: () {
          Navigator.pop(context, false);
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text("Error Login"),
        content: Text("$message"),
        actions: [
          okButton,
        ],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }
  }
}

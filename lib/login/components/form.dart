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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
        
            Container(
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
                      icon: Icon(Icons.person),
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
                      icon: Icon(Icons.lock),
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              pass = !pass;
                            });
                          },
                          child: pass == true
                              ? Icon(Icons.visibility_off, color: Colors.grey)
                              : Icon(Icons.visibility)),
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

    final localStorage = await SharedPreferences.getInstance();
    var resLogin = await CallAPI().postData(userLogin, 'login');
    var bodyLogin = json.decode(resLogin.body);
    //cek apakah login berhasil
    if (resLogin.statusCode == 200) {
      //jika iya maka
      //data akan di username dan token akan di simpan di localstorage
      // localStorage.setString('username', bodyLogin['data']['name']);
      localStorage.setString('token', bodyLogin['data']['token']);
      //setelah di simpen di localstorage
      //page berganti kehalaman home
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/API/api.dart';
import 'package:telkom_apps/API/notification.dart';
import 'package:telkom_apps/pages/dashboard/components/search.dart';
import 'package:telkom_apps/pages/dashboard/components/user.dart';
import 'package:telkom_apps/pages/login/login.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
          decoration: BoxDecoration(
              image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage('assets/image/jpeg/dashboard.png'),
          )),
          child: Column(
              children: <Widget>[User(), Search(), SizedBox(height: 40)]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          NotificationAPI.showNotification(
          title: 'Notification', body: 'testing', payload: 'checkin');
          // Widget yesButton = TextButton(
          //     child: Text(
          //       "Yes",
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     onPressed: () {
          //       Navigator.pop(context, false);
          //       logOut();
          //     },
          //     style: ElevatedButton.styleFrom(
          //       primary: Color(0xFFFF4949),
          //     ));

          // Widget noButton = TextButton(
          //   child: Text("No", style: TextStyle(color: Colors.green)),
          //   onPressed: () {
          //     Navigator.pop(context, false);
          //   },
          // );

          // AlertDialog alert = AlertDialog(
          //   title: Text("Peringatan !", style: TextStyle(color: Colors.red)),
          //   content: Text("Apakah anda yakin ingin logout?"),
          //   actions: [yesButton, noButton],
          // );

          // showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return alert;
          //     });
        },
        label: Text('Logout'),
        backgroundColor: Color(0xFFFF4949),
        icon: Icon(Icons.exit_to_app),
      ),
    );
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.get("token"); //mengambil token
    var logout = await CallAPI()
        .logout(token, 'logout'); //melakukan post token ke api logout
    if (logout.statusCode == 200) {
      //jika status code logout 200 maka akan  diarahkan ke halaman login
      prefs.clear(); //menghapus semua data di shared preferences
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }
  }
}

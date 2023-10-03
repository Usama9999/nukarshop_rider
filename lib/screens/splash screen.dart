import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rider_app_nukarshop/screens/MainScreen.dart';
import 'package:rider_app_nukarshop/screens/emialScreen.dart';
import 'package:rider_app_nukarshop/tricks/Login%20or%20NOt.dart';
import 'package:rider_app_nukarshop/tricks/configSize.dart';

class splashScreen extends StatefulWidget {
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  // var isLoading = true;
  //
  _fetching() async {
    LoginDetails.checking();
    FlutterSecureStorage storage = FlutterSecureStorage();
    var check = await storage.read(key: 'isLogin');
    if (check != null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => EmailScreen()));
    }
  }

  @override
  void initState() {
    _fetching();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text(
                "NukarShop",
                style: TextStyle(
                    fontSize: 4.5 * ConfigSize.textMultiplier,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).selectedRowColor),
              ),
              new Text(
                "we deliver anything anywhere anytime",
                style: TextStyle(
                    fontSize: 1.2 * ConfigSize.textMultiplier,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ],
          ),
        ));
  }
}

import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rider_app_nukarshop/screens/MainScreen.dart';
import 'package:rider_app_nukarshop/tricks/Login%20or%20NOt.dart';
import 'package:rider_app_nukarshop/tricks/configSize.dart';
import 'package:rider_app_nukarshop/tricks/widgets.dart';
import 'package:http/http.dart' as http;

class EmailScreen extends StatefulWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  var isLoading = false;
  var _obscure = true;
  var emailController = new TextEditingController();
  var passwordController = new TextEditingController();
  void sendToken(int ids, String token) async {
    var queryParameters = {
      'id': '$ids',
      'app_tocken': '$token',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/updateRiderAppTocken'),
      body: queryParameters,
    );
    var check = await json.decode(response.body);
  }

  Future<List<String>> confirmEmail(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    var queryParameters = {
      'email': '$email',
      'password': '$password',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/riderLoginEmailApp'),
      body: queryParameters,
    );
    var check = await json.decode(response.body);

    String id = check['id'].toString();
    String name = check['name'];
    String success = check['success'];
    String job_type = check['job_type'].toString();
    String shopType = check['shop_id'].toString();
    return [id, name, success, job_type, shopType];
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: isLoading == false
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 3.76 * ConfigSize.heightMultiplier,
                      horizontal: 7.65 * ConfigSize.paddingWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new Text(
                        "Login",
                        style: Theme.of(context).textTheme.headline1,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 2.51 * ConfigSize.heightMultiplier,
                      ),
                      new Text(
                        "Please enter your email and password below to proceed next ",
                        style: Theme.of(context).textTheme.headline2,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 6.28 * ConfigSize.heightMultiplier,
                      ),
                      new Form(
                          key: _formKey,
                          child: new Column(
                            children: [
                              Container(
                                width: 84.18 * ConfigSize.paddingWidth,
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: widgets()
                                      .decoration('abc@gmail.com', context),
                                  validator: (value) {
                                    if (value!.isEmpty) return "invalid email";
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 2.33 * ConfigSize.heightMultiplier,
                              ),
                              Container(
                                width: 84.18 * ConfigSize.paddingWidth,
                                child: TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      suffix: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscure = _obscure == false
                                                  ? true
                                                  : false;
                                            });
                                          },
                                          child: _obscure == true
                                              ? Text('Show')
                                              : Text('Hide')),
                                      fillColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      hintText: 'password',
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2.13 *
                                              ConfigSize.heightMultiplier,
                                          horizontal:
                                              5.10 * ConfigSize.paddingWidth)),
                                  obscureText: _obscure,
                                  validator: (value) {
                                    if (value!.length < 8)
                                      return "Must be 8 character long";
                                  },
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 2.51 * ConfigSize.heightMultiplier,
                      ),
                      GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              List<String> ok = await confirmEmail(
                                  emailController.text,
                                  passwordController.text);
                              if (ok[2] == '1') {
                                FlutterSecureStorage storage =
                                    FlutterSecureStorage();
                                storage.write(key: 'isLogin', value: '1');
                                storage.write(key: 'id', value: ok[0]);
                                storage.write(key: 'name', value: ok[1]);
                                storage.write(key: 'type', value: ok[3]);
                                storage.write(key: 'shop', value: ok[4]);
                                LoginDetails.checking();
                                var token =
                                    await FirebaseMessaging.instance.getToken();
                                sendToken(int.parse(ok[0]), token!);
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MainScreen()));
                              } else if (ok[2] == '0') {
                                setState(() {
                                  isLoading = false;
                                });
                                widgets().showErrorDialogue(
                                    context, "Wrong password. Try agian!");
                              }
                            }
                          },
                          child: widgets().button(context, "Proceed", 1)),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

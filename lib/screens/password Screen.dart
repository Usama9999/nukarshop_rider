import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rider_app_nukarshop/tricks/configSize.dart';
import 'package:rider_app_nukarshop/tricks/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'address screen.dart';


class newPassword extends StatefulWidget {
   String email;
  newPassword(this.email);
  @override
  _newPasswordState createState() => _newPasswordState();
}

class _newPasswordState extends State<newPassword> {

  final passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  double lat =0.0;
  double long=0.0;

  Future<Position> _getLocation() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
  Future<List<String>> getLoggedIn(String code) async
  {
    setState(() {
      isLoading = true;
    });
    var queryParameters = {
      'email': '${widget.email}',
      'password': '$code'
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/appEmailLogin'),
      body: queryParameters,
    );
    var check = await json.decode(response.body);
    if(check == false)
      {
        return ['','',''];
      }
    var id = check['userId'].toString();
    var userName = check['userName'];
    var email = check['userEmail'];
    return [id,userName,email];
  }
  var _obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: isLoading == false?Container(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.76*ConfigSize.heightMultiplier,horizontal:7.65*ConfigSize.paddingWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Text("Password ",style: Theme.of(context).textTheme.headline1,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                new Text("Please enter your password to logged in ",style: Theme.of(context).textTheme.headline2,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,),
                SizedBox(height: 50,),
                new Form(
                    key: _formKey,
                    child: new Column(
                      children: [
                        Container(
                          width: 84.18 * ConfigSize.paddingWidth,
                          child: TextFormField(
                            controller: passwordController,
                            decoration:InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                suffix: GestureDetector(
                                    onTap: ()
                                    {
                                      setState(() {
                                        _obscure = _obscure == false? true:false;
                                      });
                                    },
                                    child: _obscure == true?Text('Show'):Text('Hide')),
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                hintText: 'password',
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 2.13 * ConfigSize.heightMultiplier, horizontal: 5.10*ConfigSize.paddingWidth)),
                            obscureText: _obscure,
                            validator: (value) {
                              if (value!.length <8)
                                return "Must be 8 character long";
                            },
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 20,),
                GestureDetector(
                    onTap: ()
                    async {
                      if(_formKey.currentState!.validate())
                      {
                        var checked = await getLoggedIn(passwordController.text);
                        if(checked[0].isEmpty)
                          {
                            setState(() {
                              isLoading = false;
                            });
                            widgets().showErrorDialogue(context, "Wrong password! try later");
                          }
                        else {
                          final storage = new FlutterSecureStorage();
                          await storage.write(key: 'id', value: checked[0]);
                          await storage.write(key: 'name', value: checked[1]);
                          await storage.write(key: 'email', value: checked[2]);
                          await storage.write(key: 'isLogin', value: 'yes');
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          final double? lati = prefs.getDouble('lat');
                          final double? longi = prefs.getDouble('long');
                          if(lati != null && longi != null)
                          {
                            print(lati);
                            print(longi);
                            lat = lati;
                            long = longi;
                          }
                          else
                          {
                            Position position = await _getLocation();
                            lat = position.latitude;
                            long = position.longitude;
                          }
                          setState(() {
                            isLoading = false;
                          });
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MapScreen(lat,long)));
                        }
                      }
                    },
                    child: widgets().button(context, "Login",0)),
                SizedBox(height: 3*ConfigSize.heightMultiplier,),
                InkWell(
                  onTap: ()
                  async {

                  },
                  child:   new Text("Forgot? reset",style: TextStyle(
                    fontSize: 16,fontWeight: FontWeight.bold,
                    color: Theme.of(context).selectedRowColor,

                  ),),
                )
              ],
            ),
          ),
        ):Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

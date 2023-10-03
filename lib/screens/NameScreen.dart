import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rider_app_nukarshop/tricks/Login%20or%20NOt.dart';
import 'package:rider_app_nukarshop/tricks/configSize.dart';
import 'package:rider_app_nukarshop/tricks/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'address screen.dart';
class NameScreen extends StatefulWidget {
  final int id;
  NameScreen(this.id);
  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {

  var nameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _name = new TextEditingController();
  var isLoading = false;
  double lat =0.0;
  double long=0.0;
  Future<List<String>> setName(String code) async
  {
    setState(() {
      isLoading = true;
    });
    var queryParameters = {
      'id': '${widget.id}',
      'name': '$code'
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/updateUserName'),
      body: queryParameters,
    );
    var check = await json.decode(response.body);
    var id = check['userId'].toString();
    var userName = check['userName'];
    var email = check['userEmail'];
    return [id,userName,email];
  }
  Future<Position> _getLocation() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
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
                new Text("What's your name? ",style: Theme.of(context).textTheme.headline1,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                new Text("Your name helps captains to confirm who they are picking up",style: Theme.of(context).textTheme.headline2,
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
                            decoration: widgets().decoration('Enter your full name',context),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Invalid input";
                            },
                            controller: _name,
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 20,),
                GestureDetector(
                    onTap: () async {
                      if(_formKey.currentState!.validate())
                      {
                        var checked = await setName(_name.text);
                        final storage = new FlutterSecureStorage();
                        await storage.write(key: 'id', value: checked[0]);
                        await storage.write(key: 'name', value: checked[1]);
                        await storage.write(key: 'email', value: checked[2]);
                        await storage.write(key: 'isLogin', value: 'yes');
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        final double? lati = prefs.getDouble('lat');
                        final double? longi = prefs.getDouble('long');
                        LoginDetails.checking();
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
                    },
                    child: widgets().button(context, "Submit",0)),
                SizedBox(height: 3*ConfigSize.heightMultiplier,),
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

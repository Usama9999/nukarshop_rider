
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class Profile extends StatefulWidget {

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var isloading = false;
  var email = '';
  var phone = '';
  var name = '';
  void getDetails() async
  {
    if(this.mounted)
      setState(() {
     isloading = true;
      });
    FlutterSecureStorage storage = FlutterSecureStorage();
    var id  = await storage.read(key: 'id');
    var queryParameters = {
      'id': '$id',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/getRiderById'),
      body: queryParameters,
    );
    var result = json.decode(response.body);
    if(result !=null)
      {
        name = result['name'];
        phone = result['mobile'];
        email = result['email'];
        setState(() {
          isloading = false;
        });
      }

  }
  @override
  void initState() {
    getDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme
            .of(context)
            .primaryColor),
        title: new Text('Profile',style: TextStyle(
            color: Colors.black,fontWeight: FontWeight.bold
        ),),
      ),
      body: isloading ==false?ListView(
        padding: EdgeInsets.all(15),
        children: [
          Card(
            child: ListTile(
              title: Text("Full Name:"),
              subtitle: Text(name),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Email :"),
              subtitle: Text(email),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Phone Number:"),
              subtitle: Text(phone),
            ),
          ),
        ],
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}

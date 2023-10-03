import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
class Earning extends StatefulWidget {
  @override
  _EarningState createState() => _EarningState();
}

class _EarningState extends State<Earning> {
  var isLoading = false;
  var earnings;
  void earning() async
  {
    setState(() {
      isLoading= true;
    });
    FlutterSecureStorage storage = FlutterSecureStorage();
    var id  = await storage.read(key: 'id');
    var queryParameters = {
      'rider_id': '$id',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/riderEarningToday'),
      body: queryParameters,
    );
    var result = json.decode(response.body);
    earnings = result;
    setState(() {
      isLoading = false;
    });
    }
    @override
  void initState() {
      earning();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme
            .of(context)
            .primaryColor),
        title: new Text('Earning',style: TextStyle(
            color: Colors.black,fontWeight: FontWeight.bold
        ),),
      ),
      body: isLoading == false?ListView(
        padding: EdgeInsets.all(15),
        children: [
          Align(
              alignment: Alignment.center,
              child: new Text('TODAY',style: Theme.of(context).textTheme.headline1,)),
SizedBox(height: 20,),
          Align(
              alignment: Alignment.center,
              child: new Text('Rs. $earnings',style: Theme.of(context).textTheme.headline1,)),

        ],
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}

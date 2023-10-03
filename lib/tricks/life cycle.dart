import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager(this.child);
  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager> with WidgetsBindingObserver {

  void updateLocations() async
  {
    FlutterSecureStorage storage = FlutterSecureStorage();
    var id =await storage.read(key: 'id');
    var type =await storage.read(key: 'type');
    var queryParameters = {
      'rider_id': '$id',
      'lat': '1',
      'lng': '1',
      'status': '0',
      'job_type':'$type'

    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/updateRidersLocation'),
      body: queryParameters,
    );
  }
  void updateLocation() async
  {
    FlutterSecureStorage storage = FlutterSecureStorage();
    var id =await storage.read(key: 'id');
    var type =await storage.read(key: 'type');
    var queryParameters = {
      'rider_id': '$id',
      'lat': '0',
      'lng': '0',
      'status': '0',
      'job_type':'$type'

    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/updateRidersLocation'),
      body: queryParameters,
    );
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(LifecycleEventHandler(
        detachedCallBack: () async => updateLocation(),
        resumeCallBack: () async {updateLocations();}));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('AppLifecycleState: $state');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}
class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.detachedCallBack,this.resumeCallBack});
  late Timer _timer;
  var resumeCallBack;
  var detachedCallBack;

//  @override
//  Future<bool> didPopRoute()

//  @override
//  void didHaveMemoryPressure()

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {

    switch (state) {
      case AppLifecycleState.inactive:
        {
          print('inactive');
        }
        break;
      case AppLifecycleState.paused:
        {
          _timer = Timer.periodic(Duration(seconds: 7), (timer) async {
         print('pasued');
            // var position = await Geolocator.getCurrentPosition(
            //     desiredAccuracy: LocationAccuracy.high);
            await resumeCallBack();
          });
        }
        break;
      case AppLifecycleState.detached:
        {
          print('in detached');
          var queryParameters = {
            'rider_id': '60',
            'lat': '0',
            'lng': '0',
            'status': '0',
            'job_type':'2'
          };
          http.Response response = await http.post(
            Uri.parse('https://nukarshop.pk/api/updateRidersLocation'),
            body: queryParameters,
          );
        }
        break;
      case AppLifecycleState.resumed:
       print('RESUME');
       _timer.cancel();
        break;
    }
  }

//  @override
//  void didChangeLocale(Locale locale)

//  @override
//  void didChangeTextScaleFactor()

//  @override
//  void didChangeMetrics();

//  @override
//  Future<bool> didPushRoute(String route)
}
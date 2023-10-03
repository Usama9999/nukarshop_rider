import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:location_permissions/location_permissions.dart';
import 'package:rider_app_nukarshop/screens/Orders%20Scren.dart';
import 'package:rider_app_nukarshop/services/background%20running.dart';

import 'package:rider_app_nukarshop/tricks/ListviewBehavious.dart';
import 'package:rider_app_nukarshop/tricks/configSize.dart';
import 'package:rider_app_nukarshop/tricks/widgets.dart';

import 'drawer.dart';
import 'emialScreen.dart';

class MapScreen extends StatefulWidget {
  late Timer _timer;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late TabController tabController;
  List<Tab> myTab = [
    Tab(
      child: Text('ok'),
    ),
    Tab(
      child: Text('not'),
    ),
  ];
  var apiKey = 'AIzaSyCRB5CV2wxWa08IDpw5ulE8tqnEl8zCBeg';
  final addresbar = new TextEditingController();
  Completer<GoogleMapController> _googleMapController = Completer();
  late String address;
  double latitude = 31.52651721759199;
  double longitude = 74.34527669101954;
  List<Place> place = [];
  var toShow = false;
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (addresbar.text == '') {
      toShow = false;
    }
  }

  void updateLocation(var ids, var lat, var lng, var status, var type) async {
    var queryParameters = {
      'rider_id': '$ids',
      'lat': '$lat',
      'lng': '$lng',
      'status': '$status',
      'job_type': '$type'
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/updateRidersLocation'),
      body: queryParameters,
    );
  }

  Future<void> _askPermission() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
  }

  @override
  void initState() {
    _askPermission();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: new Text(
          'Home',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              new Text(Status.online == true ? 'Go Offline' : 'Go Online',
                  style: TextStyle(color: Colors.black)),
              new Switch(
                  inactiveThumbColor: Colors.black,
                  activeColor: Theme.of(context).primaryColor,
                  value: Status.online,
                  onChanged: (value) async {
                    setState(() {
                      Status.online = value;
                    });
                    FlutterSecureStorage storage = FlutterSecureStorage();
                    var id = await storage.read(key: 'id');
                    var type = await storage.read(key: 'type');
                    if (value == true) {
                      var position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                      updateLocation(
                          id, position.latitude, position.longitude, 1, type);
                      widget._timer =
                          Timer.periodic(Duration(seconds: 10), (timer) async {
                        var position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);
                        updateLocation(
                            id, position.latitude, position.longitude, 1, type);
                      });
                    } else {
                      var position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                      updateLocation(
                          id, position.latitude, position.longitude, 0, type);
                      widget._timer.cancel();
                    }
                  }),
            ],
          )
        ],
      ),
      drawer: CustomDrawer(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _googleMapController.complete(controller);
            },
            initialCameraPosition:
                CameraPosition(target: LatLng(latitude, longitude), zoom: 17.5),
            zoomControlsEnabled: false,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onCameraIdle: () async {
              List<Placemark> placemarks =
                  await placemarkFromCoordinates(latitude, longitude);
              setState(() {
                addresbar.text =
                    '${placemarks[0].street},${placemarks[0].subLocality},${placemarks[0].locality}';
              });
            },
            onCameraMove: (position) {
              setState(() {
                latitude = position.target.latitude;
                longitude = position.target.longitude;
              });
            },
            //  myLocationEnabled: true,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: InkWell(
                onTap: () async {
                  if (Status.online == true)
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => OrdersScreen()));
                  else
                    widgets().showErrorDialogue(
                        context, "please get online to check orders");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 1.25 * ConfigSize.paddingWidth),
                  height: 5.02 * ConfigSize.heightMultiplier,
                  decoration: BoxDecoration(
                      color: Theme.of(context).selectedRowColor,
                      border: Border.all(
                          color: Theme.of(context).selectedRowColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Text(
                        'Available Deliveries',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      new Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      )
                    ],
                  ),
                )),
          ),
          Positioned(
              top: 0,
              child: toShow == true
                  ? Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height / 2.8,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView.builder(
                            itemCount: place.length,
                            itemBuilder: (context, index) {
                              Place p = place[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      addresbar.text = p.place;
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        toShow = false;
                                      });
                                      List<Location> locations =
                                          await locationFromAddress(
                                              addresbar.text);
                                      navigationToSearchedPlace(
                                          locations[0].latitude,
                                          locations[0].longitude);
                                    },
                                    child: ListTile(
                                      leading: Icon(Icons.location_on),
                                      title: new Text(p.place,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                  Divider(
                                    height: 2,
                                  )
                                ],
                              );
                            }),
                      ))
                  : new Container()),
          // new Icon(
          //   Icons.location_on,
          //   size: 40,
          //   color: Theme
          //       .of(context)
          //       .primaryColor,
          // )
        ],
      ),
    );
  }

  Future<void> findPlaces(
      String placeid, String api) async // to get google places api result
  {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${placeid}&key=${api}&sessiontoken=1234567890';
    var response = await http.get(Uri.parse(url));
    var result = await json.decode(response.body);
    List<dynamic> list = result['predictions'];
    place = [];
    for (int i = 0; i < list.length; i++) {
      var p = Place(list[i]['description']);
      place.add(p);
    }
    if (place.isNotEmpty) {
      setState(() {
        toShow = true;
      });
    } else {
      setState(() {
        toShow = false;
      });
    }
  }

  void navigationToSearchedPlace(double lat, double long) async {
    final GoogleMapController _controller = await _googleMapController.future;
    setState(() {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, long), zoom: 17.5)));
    });
  }

  void CurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

class Place {
  late String place;
  Place(this.place);
}

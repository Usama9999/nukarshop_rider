import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app_nukarshop/models/Availale%20Orders.dart';
import 'package:rider_app_nukarshop/tricks/configSize.dart';
import 'package:rider_app_nukarshop/tricks/widgets.dart';
import 'Orders Scren.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

class OrdersDetails extends StatefulWidget {
  int orderid;
  OrdersDetails(this.orderid);
  @override
  _OrdersDetailsState createState() => _OrdersDetailsState();
}

class _OrdersDetailsState extends State<OrdersDetails> {
  Future<void> _launchMaps(
    var oLat,
    var oLang,
    var dLat,
    var dLang,
  ) async {
    var url =
        "https://www.google.com/maps/dir/?api=1&origin=$oLat,$oLang&destination=$dLat,$dLang&travelmode=driving&dir_action=navigate";
    await launch(url);
  }

  var toProceedTimer;
  var isLoading = false;
  List<OrdersForRider> orders = [];
  late Timer _timer;
  late Position position;
  var passcode;
  Future<void> GetData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        toProceedTimer = false;
      });
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var queryParameters = {
      'order_id': '${widget.orderid}',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/ordersByIdRider'),
      body: queryParameters,
    );
    var result = response.body;
    orders = ordersForRiderFromJson(result);
    if (orders.length > 0) {
      initialize();
      if (mounted) {
        setState(() {
          isLoading = false;
          toProceedTimer = true;
        });
      }
    }
  }

  Future<void> GetDataAgain() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var queryParameters = {
      'order_id': '${widget.orderid}',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/ordersByIdRider'),
      body: queryParameters,
    );
    var result = response.body;
    orders = ordersForRiderFromJson(result);
    if (orders.length > 0) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<dynamic> updateStatus(var status) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    var id = await storage.read(key: 'id');
    print(id);
    if (mounted) {
      setState(() {
        isLoading = true;
        toProceedTimer = false;
      });
    }

    var queryParameters = {
      'rider_id': '$id',
      'order_id': '${orders[0].orderId}',
      'order_status': '$status'
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/updateOrderPickedByRider'),
      body: queryParameters,
    );
    dynamic list = json.decode(response.body);
    passcode = list;
    return list;
  }

  List<Marker> markers = [];
  Completer<GoogleMapController> _googleMapController = Completer();
  var buttonText = 'accept';

  final Set<Polyline> _polyline = {};
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  initialize() async {
    final Uint8List Shop = await getBytesFromAsset('images/origan.png', 150);
    final Uint8List Customer =
        await getBytesFromAsset('images/destination.png', 150);
    // print(position.longitude);
    Marker CustomerMarker = Marker(
      markerId: MarkerId('customer'),
      position: LatLng(
          double.parse(orders[0].orderLat), double.parse(orders[0].orderLng)),
      infoWindow: InfoWindow(title: 'Customer'),
      icon: BitmapDescriptor.fromBytes(Customer),
    );
    Marker ShopMarker = Marker(
      markerId: MarkerId('Shop'),
      position: LatLng(
          double.parse(orders[0].shopLat), double.parse(orders[0].shopLng)),
      infoWindow: InfoWindow(title: 'Shop'),
      icon: BitmapDescriptor.fromBytes(Shop),
    );
    markers.add(CustomerMarker);
    markers.add(ShopMarker);
    setState(() {});
  }

  customCameraZoom() async {
    double miny =
        (double.parse(orders[0].shopLat) <= double.parse(orders[0].orderLat))
            ? double.parse(orders[0].shopLat)
            : double.parse(orders[0].orderLat);
    double minx =
        (double.parse(orders[0].shopLng) <= double.parse(orders[0].orderLng))
            ? double.parse(orders[0].shopLng)
            : double.parse(orders[0].orderLng);
    double maxy =
        (double.parse(orders[0].shopLat) <= double.parse(orders[0].orderLat))
            ? double.parse(orders[0].orderLat)
            : double.parse(orders[0].shopLat);
    double maxx =
        (double.parse(orders[0].shopLng) <= double.parse(orders[0].orderLng))
            ? double.parse(orders[0].orderLng)
            : double.parse(orders[0].shopLng);

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

// Accommodate the two locations within the
// camera view of the ap
    final GoogleMapController _controller = await _googleMapController.future;
    _controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );
  }

  @override
  void initState() {
    GetData();
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      if (toProceedTimer == true) GetDataAgain();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: true,
        title: new Text(
          'Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading == false
          ? orders[0].orderStatus != 7
              ? Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: Stack(
                          children: [
                            GoogleMap(
                              onMapCreated: (GoogleMapController controller) {
                                if (mounted) {
                                  _googleMapController.complete(controller);
                                  customCameraZoom();
                                }
                              },
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      position.latitude, position.longitude),
                                  zoom: 11.5),
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: true,
                              myLocationEnabled: true,
                              mapToolbarEnabled: false,
                              markers: markers.map((e) => e).toSet(),
                              //  myLocationEnabled: true,
                            ),
                            Positioned(
                                right: 10,
                                bottom: 10,
                                child: Column(
                                  children: [
                                    AbsorbPointer(
                                        absorbing: orders[0].orderStatus < 4
                                            ? true
                                            : false,
                                        child: GestureDetector(
                                          onTap: () {
                                            _launchMaps(
                                                position.latitude,
                                                position.longitude,
                                                double.parse(
                                                    orders[0].orderLat),
                                                double.parse(
                                                    orders[0].orderLng));
                                          },
                                          child: new Container(
                                            height: 5.02 *
                                                ConfigSize.heightMultiplier,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(1, 2),
                                                  )
                                                ]),
                                            child: Row(
                                              children: [
                                                Image(
                                                    image: AssetImage(
                                                        'images/PlaceHolder.png')),
                                                new Icon(
                                                  Icons.directions,
                                                  size: 4.39 *
                                                      ConfigSize
                                                          .heightMultiplier,
                                                  color: Colors.blue,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                    Divider(),
                                    AbsorbPointer(
                                      absorbing: orders[0].orderStatus < 4
                                          ? true
                                          : false,
                                      child: GestureDetector(
                                        onTap: () {
                                          _launchMaps(
                                              position.latitude,
                                              position.longitude,
                                              double.parse(orders[0].shopLat),
                                              double.parse(orders[0].shopLng));
                                        },
                                        child: Container(
                                          height: 5.02 *
                                              ConfigSize.heightMultiplier,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  offset: Offset(1, 2),
                                                )
                                              ]),
                                          child: Row(
                                            children: [
                                              Image(
                                                  image: AssetImage(
                                                      'images/default_store_icon.jpg')),
                                              new Icon(
                                                Icons.directions,
                                                size: 4.39 *
                                                    ConfigSize.heightMultiplier,
                                                color: Colors.red,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 30.63 * ConfigSize.heightMultiplier,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 1),
                      ),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.grey.shade200,
                            height: 5 * ConfigSize.heightMultiplier,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 5 * ConfigSize.heightMultiplier,
                                    decoration: BoxDecoration(),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //  new Text('20 min',style: Theme.of(context).textTheme.headline4),
                                      ],
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 5 * ConfigSize.heightMultiplier,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // new Text('22.00 Km',style: Theme.of(context).textTheme.headline4,),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (orders[0].orderStatus == 5) {
                                        bool ok = await updateStatus(6);
                                        if (ok == true) {
                                          GetData();
                                        }
                                      } else if (orders[0].orderStatus == 6) {
                                        bool ok = await updateStatus(7);
                                        if (ok == true) {
                                          GetData();
                                        }
                                      }
                                    },
                                    child: AbsorbPointer(
                                      absorbing: orders[0].orderStatus < 5
                                          ? true
                                          : false,
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 6.28 *
                                              ConfigSize.heightMultiplier,
                                          color: Theme.of(context)
                                              .selectedRowColor,
                                          child: new Text(
                                            orders[0].orderStatus == 6
                                                ? 'End Delivery'
                                                : 'Start Delivery',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.78 * ConfigSize.paddingWidth,
                                  vertical: 0.87 * ConfigSize.heightMultiplier),
                              margin: EdgeInsets.symmetric(
                                  vertical: 1 * ConfigSize.heightMultiplier),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'images/otherPlaceHolder.png'),
                                          radius: 3.01 *
                                              ConfigSize.heightMultiplier),
                                      SizedBox(
                                        width: 2.55 * ConfigSize.paddingWidth,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: 52.22 *
                                                  ConfigSize.widthMultiplier,
                                              child: new Text(
                                                '${orders[0].shopName}',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                              )),
                                          new Text(
                                            'Order # ${orders[0].uniqueId}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                          SizedBox(
                                            height: 1.25 *
                                                ConfigSize.heightMultiplier,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.green),
                                                child: Icon(
                                                  Icons.home,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.7 *
                                                    ConfigSize.widthMultiplier,
                                              ),
                                              Container(
                                                  width: 48.46 *
                                                      ConfigSize
                                                          .widthMultiplier,
                                                  child: new Text(
                                                      '${orders[0].shippingAdd}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4)),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          orders[0].orderStatus >= 5
                                              ? Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          color: Colors.red),
                                                      child: Icon(
                                                        Icons.phone,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 0.76 *
                                                          ConfigSize
                                                              .widthMultiplier,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() async {
                                                          await launch(
                                                              'tel:+${orders[0].phone}');
                                                        });
                                                      },
                                                      child: Container(
                                                          width: 48.46 *
                                                              ConfigSize
                                                                  .widthMultiplier,
                                                          child: new Text(
                                                            '${orders[0].phone}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4,
                                                          )),
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(),
                                          SizedBox(
                                            height:
                                                1 * ConfigSize.heightMultiplier,
                                          ),
                                          orders[0].orderStatus >= 5
                                              ? GestureDetector(
                                                  onTap: () {
                                                    widgets().showErrorDialogue(
                                                        context,
                                                        '${orders[0].customer_note}');
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 0.76 *
                                                            ConfigSize
                                                                .widthMultiplier,
                                                        vertical: 0.37 *
                                                            ConfigSize
                                                                .heightMultiplier),
                                                    child: Text("Instructions",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor)),
                                                  ),
                                                )
                                              : SizedBox(),
                                          orders[0].orderStatus == 3
                                              ? Container(
                                                  width: 48.46 *
                                                      ConfigSize
                                                          .widthMultiplier,
                                                  child: new Text(
                                                    'CODE: ${passcode}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline1,
                                                  ))
                                              : SizedBox()
                                        ],
                                      ),
                                    ],
                                  ),
                                  orders[0].orderStatus == 2
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            dynamic ok = await updateStatus(3);
                                            GetData();
                                            // if(ok == true)
                                            // {
                                            //   GetData();
                                            // }
                                          },
                                          child: new Text('Accept',
                                              style: TextStyle(
                                                  fontSize: 2.55 *
                                                      ConfigSize
                                                          .widthMultiplier)))
                                      : new Text(
                                          "Accepted",
                                          style: TextStyle(
                                              fontSize: 2.55 *
                                                  ConfigSize.widthMultiplier),
                                        )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Order has been completed!',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      new ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => OrdersScreen()));
                          },
                          child: Text(
                            'Check another',
                          ))
                    ],
                  ),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

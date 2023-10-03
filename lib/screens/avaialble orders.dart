import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:rider_app_nukarshop/models/Availale%20Orders.dart';
import 'package:rider_app_nukarshop/tricks/Login%20or%20NOt.dart';
import 'package:rider_app_nukarshop/tricks/configSize.dart';

import 'OrdersDetails Screens.dart';

class AvailableOrders extends StatefulWidget {
  @override
  _AvaiableOrdersState createState() => _AvaiableOrdersState();
}

class _AvaiableOrdersState extends State<AvailableOrders> {
  var isLoading = false;
  var hasData = false;
  List<OrdersForRider> orders = [];
  late Timer _timer;
  Future<void> getNearbyOrders() async {
    if (this.mounted) {
      setState(() {
        isLoading = true;
      });
    }
    print(LoginDetails.userId);
    print(LoginDetails.type);
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var queryParameters = {
      'lat': '${position.latitude}',
      'lng': '${position.longitude}',
      'jobtype': '${LoginDetails.type}',
      'shop_id': '${LoginDetails.shopId}',
    };
    print(position.latitude);
    print(position.longitude);

    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/searchOrdersNearby'),
      body: queryParameters,
    );
    String list = response.body;
    orders = ordersForRiderFromJson(list);
    if (orders.length > 0) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasData = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> getNearbyOrdersagain() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var queryParameters = {
      'lat': '${position.latitude}',
      'lng': '${position.longitude}',
      'jobtype': '${LoginDetails.type}',
      'shop_id': '${LoginDetails.shopId}',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/searchOrdersNearby'),
      body: queryParameters,
    );
    String list = response.body;
    if (mounted) {
      setState(() {
        orders = ordersForRiderFromJson(list);
        if (orders.isNotEmpty) {
          setState(() {
            hasData = true;
          });
        }
      });
    }
  }

  @override
  void initState() {
    getNearbyOrders();
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      getNearbyOrdersagain();
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
      body: isLoading == false
          ? hasData == true
              ? ListView(
                  padding: EdgeInsets.symmetric(
                      vertical: 1.88 * ConfigSize.heightMultiplier,
                      horizontal: 3.82 * ConfigSize.widthMultiplier),
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (context, items) {
                          var perOrder = orders[items];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => OrdersDetails(
                                              perOrder.orderId))).then((_) {
                                    hasData = false;
                                    getNearbyOrders();
                                    _timer = Timer.periodic(
                                        Duration(seconds: 15), (timer) {
                                      getNearbyOrdersagain();
                                    });
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          0.87 * ConfigSize.heightMultiplier,
                                      horizontal:
                                          1.78 * ConfigSize.widthMultiplier),
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          1.25 * ConfigSize.heightMultiplier),
                                  // height: 14.33 * ConfigSize.heightMultiplier,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'images/otherPlaceHolder.png'),
                                          radius: 3.01 *
                                              ConfigSize.heightMultiplier),
                                      SizedBox(
                                        width:
                                            2.55 * ConfigSize.widthMultiplier,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: 61.22 *
                                                  ConfigSize.widthMultiplier,
                                              child: new Text(
                                                '${perOrder.shopName}',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                              )),
                                          new Text(
                                            'Order # ${perOrder.uniqueId}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                          SizedBox(
                                            height: 1.25 *
                                                ConfigSize.heightMultiplier,
                                          ),
                                          // Row(
                                          //   children: [
                                          //     Container(
                                          //       decoration: BoxDecoration(
                                          //         borderRadius: BorderRadius.circular(100),
                                          //         color: Colors.red
                                          //       ),
                                          //       child: Icon(Icons.restaurant_menu_rounded,color: Colors.white,),
                                          //     ),
                                          //     SizedBox(width: 3,),
                                          //     // new Text('${perOrder.}'),
                                          //   ],
                                          // ),
                                          SizedBox(
                                            height: 0.63 *
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
                                                  width: 0.76 *
                                                      ConfigSize
                                                          .widthMultiplier),
                                              Container(
                                                  width: 48.46 *
                                                      ConfigSize
                                                          .widthMultiplier,
                                                  child: new Text(
                                                    '${perOrder.shippingAdd}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 0.87 *
                                                ConfigSize.heightMultiplier,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1,
                              )
                            ],
                          );
                        })
                  ],
                )
              : Center(
                  child: Image(
                    image: AssetImage('images/Hourglass.gif'),
                  ),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

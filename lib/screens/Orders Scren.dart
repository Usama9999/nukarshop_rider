import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rider_app_nukarshop/models/Availale%20Orders.dart';
import 'package:rider_app_nukarshop/tricks/widgets.dart';

import 'active order.dart';
import 'avaialble orders.dart';
class OrdersScreen extends StatefulWidget {
  @override
  _AvailableOrdersState createState() => _AvailableOrdersState();
}

class _AvailableOrdersState extends State<OrdersScreen> {
  var isLoading = false;
  List<OrdersForRider> orders = [];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme
            .of(context)
            .primaryColor),
        title: new Text('Orders',style: TextStyle(
            color: Colors.black,fontWeight: FontWeight.bold
        ),),

      ),
        bottomNavigationBar: BottomNavigationBar(
          items:[
            BottomNavigationBarItem(
              icon: Icon(Icons.event_available),
              label: 'Available Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
              label: 'Active Orders',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,

        ),
      body:Center(
    child: _selectedIndex == 0? AvailableOrders():ActiveOrders()
    )
    );
  }
}

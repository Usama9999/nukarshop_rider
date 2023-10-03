import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rider_app_nukarshop/screens/Account.dart';
import 'package:rider_app_nukarshop/screens/Earning.dart';
import 'package:rider_app_nukarshop/screens/History.dart';
import 'package:rider_app_nukarshop/screens/address%20screen.dart';
import 'package:rider_app_nukarshop/services/Notification%20plugins.dart';
import 'package:upgrader/upgrader.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    MapScreen(),
    Earning(),
    History(),
    Account(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        locaNotificationChannel.display(event);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      final routMessage = event.data['rout'];
      print(routMessage);
      if (routMessage != null) Navigator.pushNamed(context, routMessage);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<bool> message() async{
  //   widgets().showErrorDialogue(context, 'k');
  //   return Future<bool>.value(true); // this will close the app,
  //   return Future<bool>.value(false); // and this will prevent the app from exiting (by tapping the back button on home route)
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   iconTheme: IconThemeData(color: Theme
      //       .of(context)
      //       .primaryColor),
      //   title: new Text('Home',style: TextStyle(
      //     color: Colors.black,fontWeight: FontWeight.bold
      //   ),),
      //   actions: [
      //     Row(
      //       children: [
      //         new Text(Status.online == true?'Go Offline':'Go Online',style: TextStyle(
      //             color: Colors.black
      //         )),
      //         new Switch(
      //           inactiveThumbColor: Colors.black,
      //             activeColor: Theme.of(context).primaryColor,
      //             value: Status.online, onChanged: (value) async {
      //           setState((){
      //             Status.online = value;
      //           });
      //           FlutterSecureStorage storage = FlutterSecureStorage();
      //           var id =await storage.read(key: 'id');
      //           if(value == true)
      //             {
      //               _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      //                 var position = await Geolocator.getCurrentPosition(
      //                     desiredAccuracy: LocationAccuracy.high);
      //                 updateLocation(id,position.latitude,position.longitude,1);
      //               });
      //             }
      //           else
      //             {
      //               var position = await Geolocator.getCurrentPosition(
      //                   desiredAccuracy: LocationAccuracy.high);
      //               updateLocation(id,position.latitude,position.longitude,0);
      //               _timer.cancel();
      //             }
      //         }),
      //       ],
      //     )
      //   ],
      // ),
      // drawer: Drawer(child:
      //   Column(
      //     children: [
      //       SizedBox(height: 200,),
      //       new ElevatedButton(onPressed: () async {
      //         FlutterSecureStorage storage = FlutterSecureStorage();
      //         var id =await storage.read(key: 'id');
      //         var position = await Geolocator.getCurrentPosition(
      //             desiredAccuracy: LocationAccuracy.high);
      //         updateLocation(id, position.latitude, position.longitude, 0);
      //         storage.delete(key: 'isLogin');
      //         setState(() {
      //           Status.online = false;
      //         });
      //         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>EmailScreen()));
      // }, child:new Text('log out'))
      //     ],
      //   ),),
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_outlined),
              label: 'Earning',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
        ),
      ),
      body: UpgradeAlert(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}

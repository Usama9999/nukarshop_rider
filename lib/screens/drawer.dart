import 'package:flutter/material.dart';
import 'package:rider_app_nukarshop/screens/profile.dart';
import 'package:rider_app_nukarshop/services/background%20running.dart';
import 'package:rider_app_nukarshop/tricks/Login%20or%20NOt.dart';
import 'package:rider_app_nukarshop/tricks/configSize.dart';
import 'package:url_launcher/url_launcher.dart';

import 'emialScreen.dart';

class CustomDrawer extends StatefulWidget {
  @override
  State<CustomDrawer> createState() => _drawerState();
}

class _drawerState extends State<CustomDrawer> {
  _launchURL(String no) async {
    await launch(
      no,
      forceWebView: true,
    );
  }

  openPhone(String no) async {
    await launch('tel:03214883748');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new Column(
        children: [
          Stack(
            children: [
              new Container(
                height: 31.40 * ConfigSize.heightMultiplier,
                width: double.infinity,
                color: Theme.of(context).primaryColor,
              ),
              Positioned(
                  bottom: 2.51 * ConfigSize.heightMultiplier,
                  left: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: new Text(LoginDetails.name[0],
                            style: TextStyle(
                                fontSize: 2.51 * ConfigSize.textMultiplier,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      new Text(
                        LoginDetails.name,
                        style: TextStyle(
                            fontSize: 2.51 * ConfigSize.textMultiplier,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ))
            ],
          ),
          SizedBox(
            height: 2.51 * ConfigSize.heightMultiplier,
          ),
          Column(
            children: [
              OptionMake(context, 'Profile', () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Profile()));
              }, Icons.person_outline_outlined),
              // OptionMake(context, 'Favourites', (){}, Icons.favorite_border),
              // OptionMake(context, 'Addresses', (){}, Icons.location_on_outlined),
              // OptionMake(context, 'Vouchers', (){}, Icons.sticky_note_2_outlined),
              // OptionMake(context, 'Notifications', (){}, Icons.notifications_active_outlined),

              OptionMake(context, 'Help', () {
                _launchURL('https://nukarshop.pk/help');
              }, Icons.help_center_outlined),
              OptionMake(context, 'Help', () {
                setState(() async {
                 await launch('tel:03214883748');
                });
              }, Icons.help_center_outlined),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () => _launchURL('https://nukarshop.pk/terms'),
                      child: Text(
                        'Terms |',
                        style: TextStyle(
                            fontSize: 1.75 * ConfigSize.textMultiplier,
                            color: Theme.of(context).selectedRowColor,
                            fontWeight: FontWeight.bold),
                      )),
                  GestureDetector(
                      onTap: () =>
                          _launchURL('https://nukarshop.pk/privacy_policy'),
                      child: Text(' Privacy Policy',
                          style: TextStyle(
                              fontSize: 1.75 * ConfigSize.textMultiplier,
                              color: Theme.of(context).selectedRowColor,
                              fontWeight: FontWeight.bold))),
                ],
              ),
              SizedBox(
                height: 1.89 * ConfigSize.heightMultiplier,
              ),
              InkWell(
                  onTap: () {
                    LoginDetails.deleteAll();
                    LoginDetails.checking();
                    Status.online = false;
                    // MapScreen
                    setState(() {});
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => EmailScreen()),
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Log out',
                    style: Theme.of(context).textTheme.headline4,
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget OptionMake(
      BuildContext context, String heading, Function()? ontap, IconData icon) {
    return Padding(
      padding: EdgeInsets.all(11),
      child: GestureDetector(
        onTap: ontap,
        child: new Row(
          children: [
            Icon(
              icon,
              size: 2.88 * ConfigSize.heightMultiplier,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 5.10 * ConfigSize.textMultiplier,
            ),
            new Text(
              heading,
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      ),
    );
  }
}

_callNumber() async {
  // const number = '03214883748'; //set the number here
  // var res = await FlutterPhoneDirectCaller.callNumber(number);
}

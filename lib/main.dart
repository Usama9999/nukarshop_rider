import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rider_app_nukarshop/screens/Orders%20Scren.dart';
import 'package:rider_app_nukarshop/services/Notification%20plugins.dart';
import 'package:rider_app_nukarshop/tricks/configSize.dart';
import 'screens/splash screen.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    locaNotificationChannel.display(message);
    //   final routMessage = message.data['rout'];
    //   if(routMessage !=null)
    //     Navigator.pushNamed(context, routMessage);
    // });
    //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //     final routMessage = event.data['rout'];
    //     if(routMessage !=null)
    //       Navigator.pushNamed(context, routMessage);
    //   });
  }
}

main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  locaNotificationChannel.initializer();
  FirebaseMessaging.onBackgroundMessage((backgroundHandler));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
  // DevicePreview(
  //     builder: (context) =>
  // ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return OrientationBuilder(
          builder: (context, orientation) {
            ConfigSize().init(constraint, orientation);
            return MaterialApp(
              title: 'NukarShop',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: GoogleFonts.mavenPro().fontFamily,
                primarySwatch: Colors.deepPurple,
                primaryColor: Color(0xff53286f),
                selectedRowColor: Color(0xfff4b228),
                textTheme: TextTheme(
                  headline1: TextStyle(
                      fontSize: 2.76 * ConfigSize.textMultiplier,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4a4b4D)),
                  headline2: TextStyle(
                      fontSize: 1.88 * ConfigSize.textMultiplier,
                      color: Color(0xff7c7d7e)),
                  headline3: TextStyle(
                      fontSize: 2.51 * ConfigSize.textMultiplier,
                      color: Color(0xff4a4b4D),
                      fontWeight: FontWeight.bold),
                  headline4: TextStyle(
                      fontSize: 1.75 * ConfigSize.textMultiplier,
                      color: Color(0xff4a4b4D),
                      fontWeight: FontWeight.bold),
                  headline5: TextStyle(
                      fontSize: 2 * ConfigSize.textMultiplier,
                      color: Color(0xff4a4b4D),
                      fontWeight: FontWeight.bold),
                  headline6: TextStyle(
                      fontSize: 2.51 * ConfigSize.textMultiplier,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4a4b4D)),
                ),
              ),
              routes: {
                'order': (context) => OrdersScreen(),
              },
              home: splashScreen(),
            );
          },
        );
      },
    );
  }
}

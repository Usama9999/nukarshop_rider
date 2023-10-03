import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginDetails {
  static var isLogin = 'no';
  static var name = 'There';
  static var type = '';
  static var userId = '';
  static var shopId = '';

  static checking() async {
    final storage = new FlutterSecureStorage();
    String? value = await storage.read(key: 'isLogin');
    if (value != null) isLogin = value;
    String? names = await storage.read(key: 'name');
    if (names != null) name = names;
    String? riderType = await storage.read(key: 'type');
    if (riderType != null) type = riderType;
    String? userid = await storage.read(key: 'id');
    if (userid != null) userId = userid;
    String? shop = await storage.read(key: 'shop');
    if (shop != null) shopId = shop;
  }

  static deleteAll() async {
    final storage = new FlutterSecureStorage();
    await storage.deleteAll();
    name = 'There';
    type = '';
    isLogin = 'no';
    userId = '';
  }
}

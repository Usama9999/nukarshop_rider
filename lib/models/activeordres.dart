// To parse this JSON data, do
//
//     final activeOreders = activeOredersFromJson(jsonString);

import 'dart:convert';

List<ActiveOreders> activeOredersFromJson(String str) => List<ActiveOreders>.from(json.decode(str).map((x) => ActiveOreders.fromJson(x)));

String activeOredersToJson(List<ActiveOreders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ActiveOreders {
  ActiveOreders({
    required this.orderId,
    required this.uniqueId,
    required this.shopId,
    required this.shopName,
    required this.shippingAdd,
    required this.orderLat,
    required this.orderLng,
    required this.orderStatus,
    required this.orderTime,
    required this.shopLat,
    required this.shopLng,
    this.customer_note
  });

  int orderId;
  String uniqueId;
  int shopId;
  String shopName;
  String shippingAdd;
  dynamic orderLat;
  dynamic orderLng;
  int orderStatus;
  dynamic orderTime;
  String shopLat;
  String shopLng;
  dynamic customer_note;

  factory ActiveOreders.fromJson(Map<String, dynamic> json) => ActiveOreders(
    orderId: json["order_id"],
    uniqueId: json["unique_order_id"],
    shopId: json["shop_id"],
    shopName: json["shop_name"],
    shippingAdd: json["shipping_add"],
    orderLat: json["orderLat"],
    orderLng: json["orderLng"],
    orderStatus: json["order_status"],
    orderTime:json["orderTime"],
    shopLat: json["shopLat"],
    shopLng: json["shopLng"],
    customer_note: json['customer_note']
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "unique_order_id": uniqueId,
    "shop_id": shopId,
    "shop_name": shopName,
    "shipping_add": shippingAdd,
    "orderLat": orderLat == null ? null : orderLat,
    "orderLng": orderLng == null ? null : orderLng,
    "order_status": orderStatus,
    "orderTime": orderTime,
    "shopLat": shopLat,
    "shopLng": shopLng,
    "customer_note":customer_note
  };
}

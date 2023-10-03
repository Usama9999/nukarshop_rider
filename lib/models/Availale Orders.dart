// To parse this JSON data, do
//
//     final ordersForRider = ordersForRiderFromJson(jsonString);

import 'dart:convert';

List<OrdersForRider> ordersForRiderFromJson(String str) => List<OrdersForRider>.from(json.decode(str).map((x) => OrdersForRider.fromJson(x)));

String ordersForRiderToJson(List<OrdersForRider> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrdersForRider {
  OrdersForRider({
    required this.uniqueId,
    required this.shopId,
    required this.shopName,
    required this.shippingAdd,
    required this.orderId,
    required this.orderLat,
    required this.orderLng,
    required this.orderStatus,
    required this.orderTime,
    required this.shopLat,
    required this.shopLng,
    this.customer_note,
    this.phone
  });

  dynamic uniqueId;
  int shopId;
  String shopName;
  String shippingAdd;
  int orderId;
  dynamic orderLat;
  dynamic orderLng;
  int orderStatus;
  dynamic orderTime;
  String shopLat;
  String shopLng;
  dynamic customer_note;
  dynamic phone;
  factory OrdersForRider.fromJson(Map<String, dynamic> json) => OrdersForRider(
    uniqueId: json["unique_order_id"],
    shopId: json["shop_id"],
    shopName: json["shop_name"],
    shippingAdd: json["shipping_add"],
    orderId: json["order_id"],
    orderLat: json["orderLat"],
    orderLng: json["orderLng"],
    orderStatus: json["order_status"],
    orderTime: json["orderTime"],
    shopLat: json["shopLat"],
    shopLng: json["shopLng"],
      customer_note: json['customer_note'],
    phone: json['mobile']
  );

  Map<String, dynamic> toJson() => {
    "unique_order_id":uniqueId,
    "shop_id": shopId,
    "shop_name": shopName,
    "shipping_add": shippingAdd,
    "order_id": orderId,
    "orderLat": orderLat,
    "orderLng": orderLng,
    "order_status": orderStatus,
    "orderTime": orderTime,
    "shopLat": shopLat,
    "shopLng": shopLng,
    "customer_note":customer_note,
    "mobile":phone
  };
}

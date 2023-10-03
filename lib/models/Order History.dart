// To parse this JSON data, do
//
//     final orderHistory = orderHistoryFromJson(jsonString);

import 'dart:convert';

List<OrderHistory> orderHistoryFromJson(String str) => List<OrderHistory>.from(json.decode(str).map((x) => OrderHistory.fromJson(x)));

String orderHistoryToJson(List<OrderHistory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderHistory {
  OrderHistory({
    required this.orderId,
    required this.uniqueOrderId,
    required this.customerId,
    required this.shopId,
    required this.shopName,
    required this.shippingAdd,
    required this.riderCharges,
    required this.netTotal,
    required this.paymentMethod,
    required this.createdAt,
    required this.riderDeliverdAt,
  });

  int orderId;
  String uniqueOrderId;
  int customerId;
  int shopId;
  String shopName;
  String shippingAdd;
  int riderCharges;
  String netTotal;
  String paymentMethod;
  String createdAt;
  String riderDeliverdAt;

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
    orderId: json["order_id"],
    uniqueOrderId: json["unique_order_id"],
    customerId: json["customer_id"],
    shopId: json["shop_id"],
    shopName: json["shop_name"],
    shippingAdd: json["shipping_add"],
    riderCharges: json["rider_charges"],
    netTotal: json["net_total"],
    paymentMethod: json["payment_method"],
    createdAt: json["created_at"],
    riderDeliverdAt: json["rider_deliverd_at"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "unique_order_id": uniqueOrderId,
    "customer_id": customerId,
    "shop_id": shopId,
    "shop_name": shopName,
    "shipping_add": shippingAdd,
    "rider_charges": riderCharges,
    "net_total": netTotal,
    "payment_method": paymentMethod,
    "created_at": createdAt,
    "rider_deliverd_at": riderDeliverdAt,
  };
}

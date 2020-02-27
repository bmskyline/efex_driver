import 'order_model.dart';

class ShopDetailData {
  List<Order> orders = List();
  int total;
  int offset;
  int limit;

  ShopDetailData({
    this.orders,
    this.total,
    this.offset,
    this.limit,
  });

  factory ShopDetailData.fromJson(Map<String, dynamic> json) => ShopDetailData(
        orders: json["tracking"] == null
            ? List()
            : List<Order>.from(json["tracking"].map((x) => Order.fromJson(x))),
        total: json["total"] == null ? null : json["total"],
        offset: json["offset"] == null ? null : json["offset"],
        limit: json["limit"] == null ? null : json["limit"],
      );
}

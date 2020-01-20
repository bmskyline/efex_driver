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
            ? null
            : List<Order>.from(json["tracking"].map((x) => Order.fromJson(x))),
        total: json["total"] == null ? null : json["total"],
        offset: json["offset"] == null ? null : json["offset"],
        limit: json["limit"] == null ? null : json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "tracking": orders == null
            ? null
            : List<dynamic>.from(orders.map((x) => x.toJson())),
        "total": total == null ? null : total,
        "offset": offset == null ? null : offset,
        "limit": limit == null ? null : limit,
      };
}

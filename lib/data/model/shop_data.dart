import 'package:driver_app/data/model/shop_model.dart';

class ShopData {
  List<Shop> shops;
  int total;
  int offset;
  int limit;

  ShopData({
    this.shops,
    this.total,
    this.offset,
    this.limit,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) => ShopData(
        shops: json["tracking"] == null
            ? null
            : List<Shop>.from(json["tracking"].map((x) => Shop.fromJson(x))),
        total: json["total"] == null ? null : json["total"],
        offset: json["offset"] == null ? null : json["offset"],
        limit: json["limit"] == null ? null : json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "tracking": shops == null
            ? null
            : List<dynamic>.from(shops.map((x) => x.toJson())),
        "total": total == null ? null : total,
        "offset": offset == null ? null : offset,
        "limit": limit == null ? null : limit,
      };
}

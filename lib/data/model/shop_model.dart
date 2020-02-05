class Shop {
  String fromAddress;
  String fromPhone;
  String fromName;
  String totalWeight;
  String totalOrders;
  String fullCount;
  bool isActive = false;

  Shop(
      {this.fromAddress,
      this.fromPhone,
      this.fromName,
      this.totalWeight,
      this.totalOrders,
      this.fullCount,
      this.isActive});

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        fromAddress: json["from_address"] == null ? null : json["from_address"],
        fromPhone: json["from_phone"] == null ? null : json["from_phone"],
        fromName: json["from_name"] == null ? null : json["from_name"],
        totalWeight: json["total_weight"] == null ? null : json["total_weight"],
        totalOrders: json["total_orders"] == null ? null : json["total_orders"],
        fullCount: json["full_count"] == null ? null : json["full_count"],
        isActive: json["is_active"] == null ? false : json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "from_address": fromAddress == null ? null : fromAddress,
        "from_phone": fromPhone == null ? null : fromPhone,
        "from_name": fromName == null ? null : fromName,
        "total_weight": totalWeight == null ? null : totalWeight,
        "total_orders": totalOrders == null ? null : totalOrders,
        "full_count": fullCount == null ? null : fullCount,
        "is_active": isActive == null ? null : isActive,
      };


}

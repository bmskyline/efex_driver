class Shop {
  String shopId;
  String name;
  String address;
  String phone;
  String wardName;
  String districtName;
  String totalWeight;
  String totalOrders;
  String fullCount;
  bool isActive;

  Shop({
    this.shopId,
    this.name,
    this.address,
    this.phone,
    this.wardName,
    this.districtName,
    this.totalWeight,
    this.totalOrders,
    this.fullCount,
    this.isActive,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
    shopId: json["shop_id"] == null ? null : json["shop_id"],
    name: json["name"] == null ? null : json["name"],
    address: json["address"] == null ? null : json["address"],
    phone: json["phone"] == null ? null : json["phone"],
    wardName: json["ward_name"] == null ? null : json["ward_name"],
    districtName: json["district_name"] == null ? null : json["district_name"],
    totalWeight: json["total_weight"] == null ? null : json["total_weight"],
    totalOrders: json["total_orders"] == null ? null : json["total_orders"],
    fullCount: json["full_count"] == null ? null : json["full_count"],
    isActive: json["is_active"] == null ? null : json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "shop_id": shopId == null ? null : shopId,
    "name": name == null ? null : name,
    "address": address == null ? null : address,
    "phone": phone == null ? null : phone,
    "ward_name": wardName == null ? null : wardName,
    "district_name": districtName == null ? null : districtName,
    "total_weight": totalWeight == null ? null : totalWeight,
    "total_orders": totalOrders == null ? null : totalOrders,
    "full_count": fullCount == null ? null : fullCount,
    "is_active": isActive == null ? null : isActive,
  };
}

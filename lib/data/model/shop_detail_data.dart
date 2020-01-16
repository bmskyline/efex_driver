class ShopDetailData {
  List<Tracking> tracking;
  int total;
  int offset;
  int limit;

  ShopDetailData({
    this.tracking,
    this.total,
    this.offset,
    this.limit,
  });

  factory ShopDetailData.fromJson(Map<String, dynamic> json) => ShopDetailData(
    tracking: json["tracking"] == null ? null : List<Tracking>.from(json["tracking"].map((x) => Tracking.fromJson(x))),
    total: json["total"] == null ? null : json["total"],
    offset: json["offset"] == null ? null : json["offset"],
    limit: json["limit"] == null ? null : json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "tracking": tracking == null ? null : List<dynamic>.from(tracking.map((x) => x.toJson())),
    "total": total == null ? null : total,
    "offset": offset == null ? null : offset,
    "limit": limit == null ? null : limit,
  };
}
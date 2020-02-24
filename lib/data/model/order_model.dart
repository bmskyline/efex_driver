import 'package:driver_app/data/model/product_model.dart';

class Order {
  String trackingNumber;
  String fromAddress;
  String fromPhone;
  String fromName;
  String toAddress;
  String toPhone;
  String toName;
  String note;
  List<Product> products;
  String fullCount;
  String currentStatus;
  String reason;
  String img;
  DateTime dispatchAt;
  DateTime updatedTime;

  Order(
      {this.trackingNumber,
      this.fromAddress,
      this.fromPhone,
      this.fromName,
      this.toAddress,
      this.toPhone,
      this.toName,
      this.note,
      this.products,
      this.fullCount,
      this.currentStatus,
      this.reason,
      this.img,
      this.dispatchAt,
      this.updatedTime});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        trackingNumber:
            json["trackingnumber"] == null ? null : json["trackingnumber"],
        fromAddress: json["from_address"] == null ? "" : json["from_address"],
        fromPhone: json["from_phone"] == null ? "" : json["from_phone"],
        fromName: json["from_name"] == null ? "" : json["from_name"],
        toAddress: json["to_address"] == null ? "" : json["to_address"],
        toPhone: json["to_phone"] == null ? "" : json["to_phone"],
        toName: json["to_name"] == null ? "" : json["to_name"],
        note: json["note"] == null ? "" : json["note"],
        products: json["products"] == null
            ? List()
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
        currentStatus:
            json["current_status"] == null ? null : json["current_status"],
        reason: json["reason"] == null ? "" : json["reason"],
        img: json["imgurl"] == null ? "" : json["imgurl"],
        dispatchAt: json["dispatch_at"] == null
            ? null
            : DateTime.parse(json["dispatch_at"]),
        updatedTime: json["updated_time"] == null
            ? null
            : DateTime.parse(json["updated_time"]),
        fullCount: json["full_count"] == null ? "0" : json["full_count"],
      );

  int weightOfProduct() {
    int total = 0;
    for (int i = 0; i < products.length; i++) {
      total += products[i].weight;
    }
    return total;
  }
}

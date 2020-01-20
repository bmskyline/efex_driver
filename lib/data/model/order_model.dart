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

  Order({
    this.trackingNumber,
    this.fromAddress,
    this.fromPhone,
    this.fromName,
    this.toAddress,
    this.toPhone,
    this.toName,
    this.note,
    this.products,
    this.fullCount,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    trackingNumber: json["trackingnumber"] == null ? null : json["trackingnumber"],
    fromAddress: json["from_address"] == null ? null : json["from_address"],
    fromPhone: json["from_phone"] == null ? null : json["from_phone"],
    fromName: json["from_name"] == null ? null : json["from_name"],
    toAddress: json["to_address"] == null ? null : json["to_address"],
    toPhone: json["to_phone"] == null ? null : json["to_phone"],
    toName: json["to_name"] == null ? null : json["to_name"],
    note: json["note"] == null ? null : json["note"],
    products: json["products"] == null ? null : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    fullCount: json["full_count"] == null ? null : json["full_count"],
  );

  Map<String, dynamic> toJson() => {
    "trackingnumber": trackingNumber == null ? null : trackingNumber,
    "from_address": fromAddress == null ? null : fromAddress,
    "from_phone": fromPhone == null ? null : fromPhone,
    "from_name": fromName == null ? null : fromName,
    "to_address": toAddress == null ? null : toAddress,
    "to_phone": toPhone == null ? null : toPhone,
    "to_name": toName == null ? null : toName,
    "note": note == null ? null : note,
    "products": products == null ? null : List<dynamic>.from(products.map((x) => x.toJson())),
    "full_count": fullCount == null ? null : fullCount,
  };

  int weightOfProduct() {
    int total = 0;
    for(int i=0;i<products.length;i++) {
      total += products[i].weight;
    }
    return total;
  }
}

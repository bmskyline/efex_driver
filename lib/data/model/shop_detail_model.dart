import 'order_model.dart';

class ShopDetail {
  int id;
  String name;
  int totalOrders;
  String phone;
  String address;
  //List<Order> orders = List();

  ShopDetail(this.id, this.name, this.totalOrders, this.phone, this.address);

  ShopDetail.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json["name"],
        address = json["address"],
        phone = json["phone"],
        totalOrders = json["total"];
        //orders = json["orders"];
}
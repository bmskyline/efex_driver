class Shop {
  int id;
  String name;
  String address;
  String phone;
  int totalOrders;
  String time;

  Shop(this.id, this.name, this.address, this.phone, this.totalOrders,
      this.time);

  Shop.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json["name"],
        address = json["address"],
        phone = json["phone"],
        totalOrders = json["total"],
        time = json["time"];
}

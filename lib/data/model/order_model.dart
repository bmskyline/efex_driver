class Order {
  String id;
  int number;
  int weight;
  bool isCheckProduct;
  String note;

  Order(this.id, this.number, this.weight, this.isCheckProduct, this.note);

  Order.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        number = json["number"],
        weight = json["weight"],
        isCheckProduct = json["checkProduct"],
        note = json["note"];
}
class Product {
  int id;
  String name;
  int price;
  int width;
  int height;
  int length;
  int weight;
  int quantity;

  Product({
    this.id,
    this.name,
    this.price,
    this.width,
    this.height,
    this.length,
    this.weight,
    this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["ProductId"] == null ? null : json["ProductId"],
    name: json["ProductName"] == null ? null : json["ProductName"],
    price: json["ProductPrice"] == null ? null : json["ProductPrice"],
    width: json["ProductWidth"] == null ? null : json["ProductWidth"],
    height: json["ProductHeight"] == null ? null : json["ProductHeight"],
    length: json["ProductLength"] == null ? null : json["ProductLength"],
    weight: json["ProductWeight"] == null ? null : json["ProductWeight"],
    quantity: json["ProductQuantity"] == null ? null : json["ProductQuantity"],
  );

  Map<String, dynamic> toJson() => {
    "ProductId": id == null ? null : id,
    "ProductName": name == null ? null : name,
    "ProductPrice": price == null ? null : price,
    "ProductWidth": width == null ? null : width,
    "ProductHeight": height == null ? null : height,
    "ProductLength": length == null ? null : length,
    "ProductWeight": weight == null ? null : weight,
    "ProductQuantity": quantity == null ? null : quantity,
  };
}
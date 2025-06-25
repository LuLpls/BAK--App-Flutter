class Item {
  final String id;
  final String name;
  final double? quantity;
  final String? unit;
  bool purchased;

  Item({
    required this.id,
    required this.name,
    this.quantity,
    this.unit,
    this.purchased = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'purchased': purchased,
  };

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
      purchased: json['purchased'] ?? false,
    );
  }
}

class ShoppingList {
  final String id;
  final String title;

  ShoppingList({required this.id, required this.title});

  Map<String, dynamic> toJson() => {'id': id, 'title': title};

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(id: json['id'], title: json['title']);
  }
}

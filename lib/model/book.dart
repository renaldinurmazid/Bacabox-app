class Book {
  late String title;
  late double price;

  Book({
    required this.title,
    required this.price, String? id,
  });

  String? get id => null;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
    };
  }
}

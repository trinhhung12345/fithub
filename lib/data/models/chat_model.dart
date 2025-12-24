class AiResponse {
  final String message;
  final List<AiProduct> products;
  final List<String> suggestions;

  AiResponse({
    required this.message,
    required this.products,
    required this.suggestions,
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      message: json['message'] ?? "",
      products: json['products'] != null
          ? (json['products'] as List)
                .map((e) => AiProduct.fromJson(e))
                .toList()
          : [],
      suggestions: json['suggestions'] != null
          ? List<String>.from(json['suggestions'])
          : [],
    );
  }
}

class AiProduct {
  final int id;
  final String name;
  final double price;
  final String link;

  AiProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.link,
  });

  factory AiProduct.fromJson(Map<String, dynamic> json) {
    return AiProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      link: json['link'] ?? "",
    );
  }
}

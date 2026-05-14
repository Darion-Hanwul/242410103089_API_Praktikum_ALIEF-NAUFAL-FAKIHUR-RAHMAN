// Class Model untuk Produk
class Product {
  final int? id;
  final String name;
  final int price;  // HARUS int, BUKAN String
  final String description;
  final String? createdAt;
  final String? updatedAt;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
    };
  }
}

// Class Model untuk Submit Tugas - SESUAI FORMAT PDF
class SubmitTask {
  final String name;
  final int price;      // HARUS price (int), BUKAN NIM!
  final String description;
  final String githubUrl;

  SubmitTask({
    required this.name,
    required this.price,
    required this.description,
    required this.githubUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,           // Sesuai PDF halaman 5
      'description': description,
      'github_url': githubUrl,  // Sesuai PDF halaman 5
    };
  }
}
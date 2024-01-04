class Products {
  final String nama_produk;
  final double harga_produk;
  final String created_at;
  final String updated_at;

  Products({
    required this.nama_produk,
    required this.harga_produk,
    required this.created_at,
    required this.updated_at,
    String? id,
  });

  String? get id => null;

  Map<String, dynamic> toMap() {
    return {
      'nama_produk': nama_produk,
      'harga_produk': harga_produk,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

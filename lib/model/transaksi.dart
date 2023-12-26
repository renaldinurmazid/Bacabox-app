class Transaksi {
  late String id;
  final String namaPembeli;
  final String namaProduk;
  final double hargaProduk;
  final int qty;
  final double uangBayar;
  final double totalBelanja;
  final double uangKembali;

  Transaksi({
    required this.id,
    required this.namaPembeli,
    required this.namaProduk,
    required this.hargaProduk,
    required this.qty,
    required this.uangBayar,
    required this.totalBelanja,
    required this.uangKembali, required String tanggaltransaksi,
  });

  // double get totalBelanja => hargaProduk * qty;
  // double get uangKembali => uangBayar - totalBelanja;

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Masukkan id dalam toMap
      'namaPembeli': namaPembeli,
      'namaProduk': namaProduk,
      'hargaProduk': hargaProduk,
      'qty': qty,
      'uangBayar': uangBayar,
      'totalBelanja': totalBelanja,
      'uangKembali': uangKembali,
      'tanggaltransaksi': DateTime.now().toString(),
    };
  }
}

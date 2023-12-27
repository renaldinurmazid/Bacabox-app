class Transaksi {
  final String namaPembeli;
  final String namaProduk;
  final double hargaProduk;
  final int qty;
  final double uangBayar;
  final double totalBelanja;
  final double uangKembali;

  Transaksi({
    required this.namaPembeli,
    required this.namaProduk,
    required this.hargaProduk,
    required this.qty,
    required this.uangBayar,
    required this.totalBelanja,
    required this.uangKembali, required String tanggaltransaksi,
  });

  Map<String, dynamic> toMap() {
    return {
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

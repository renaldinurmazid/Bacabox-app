class Transaksi {
  final int nomor_unik;
  final String namaPembeli;
  final String namaProduk;
  final double hargaProduk;
  final int qty;
  final double uangBayar;
  final double totalBelanja;
  final double uangKembali;
  final String created_at;
  final String updated_at;

  Transaksi({
    required this.nomor_unik,
    required this.namaPembeli,
    required this.namaProduk,
    required this.hargaProduk,
    required this.qty,
    required this.uangBayar,
    required this.totalBelanja,
    required this.uangKembali, 
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'nomor_unik': nomor_unik,
      'namaPembeli': namaPembeli,
      'namaProduk': namaProduk,
      'hargaProduk': hargaProduk,
      'qty': qty,
      'uangBayar': uangBayar,
      'totalBelanja': totalBelanja,
      'uangKembali': uangKembali,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

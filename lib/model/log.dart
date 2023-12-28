class Log {
  final String id;
  final String message;
  final DateTime timestamp;
  final String userName; // Menambahkan informasi nama pengguna

  Log({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.userName,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? ''),
      userName: json['userName'] ?? '', // Mendapatkan informasi nama pengguna dari log
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'userName': userName, // Menyimpan informasi nama pengguna ke log
    };
  }
}

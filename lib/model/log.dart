class Log {
  final String id;
  final String activity;
  final DateTime created_At;
  final String userName;
  Log({
    required this.id,
    required this.activity,
    required this.created_At,
    required this.userName,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'] ?? '',
      activity: json['activity'] ?? '',
      created_At: DateTime.parse(json['created_At'] ?? ''),
      userName: json['userName'] ?? '', // Mendapatkan informasi nama pengguna dari log
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activity': activity,
      'created_At': created_At.toString(),
      'userName': userName, // Menyimpan informasi nama pengguna ke log
    };
  }
}

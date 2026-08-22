class VpnServer {
  final String id;
  final String title;
  final String description;
  final String flag;
  final String rawUrl;
  final String host;
  final int port;
  final String category; // 'WIFI', 'LTE', 'AUTO'
  int ping; // в миллисекундах

  VpnServer({
    required this.id,
    required this.title,
    required this.description,
    required this.flag,
    required this.rawUrl,
    required this.host,
    required this.port,
    required this.category,
    this.ping = -1,
  });

  bool get isAuto => category == 'AUTO';
}

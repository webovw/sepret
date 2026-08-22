import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/server_model.dart';

class SubscriptionService {
  static const String defaultSubUrl = "https://sub.phlux.bine.me";

  static Future<List<VpnServer>> fetchServers({String url = defaultSubUrl}) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        String body = response.body.trim();
        String decodedText = "";
        try {
          decodedText = utf8.decode(base64.decode(base64.normalize(body)));
        } catch (_) {
          decodedText = body;
        }
        return parseSubscriptionText(decodedText);
      }
    } catch (_) {}
    return getFallbackServers();
  }

  static List<VpnServer> parseSubscriptionText(String text) {
    List<VpnServer> servers = [];
    final lines = text.split(RegExp(r'\r?\n'));

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith("#") || line.contains("0.0.0.0:443")) {
        continue;
      }

      if (line.startsWith("vless://")) {
        try {
          final uri = Uri.parse(line);
          final host = uri.host;
          final port = uri.port == 0 ? 443 : uri.port;
          String fragment = uri.fragment;

          String title = "Phlux Node";
          String description = "VLESS Reality";

          if (fragment.contains("?serverDescription=")) {
            final parts = fragment.split("?serverDescription=");
            title = parts[0];
            try {
              description = utf8.decode(base64.decode(base64.normalize(parts[1])));
            } catch (_) {
              description = parts[1];
            }
          } else {
            title = fragment.isNotEmpty ? fragment : "Phlux Node";
          }

          String flag = "🌐";
          String category = "WIFI";

          if (title.contains("Нидерланды") || title.contains("🇳🇱")) flag = "🇳🇱";
          if (title.contains("Финляндия") || title.contains("🇫🇮")) flag = "🇫🇮";
          if (title.contains("Латвия") || title.contains("🇱🇻")) flag = "🇱🇻";
          if (title.contains("Германия") || title.contains("🇩🇪")) flag = "🇩🇪";
          if (title.contains("Польша") || title.contains("🇵🇱")) flag = "🇵🇱";
          if (title.contains("Россия") || title.contains("🇷🇺")) flag = "🇷🇺";
          if (title.contains("Обход") || title.contains("🇪🇺")) flag = "🇪🇺";

          if (title.contains("Автоподбор")) {
            category = "AUTO";
            flag = "⚡";
          } else if (title.contains("Обход") || description.contains("LTE")) {
            category = "LTE";
          }

          servers.add(VpnServer(
            id: "${host}_$port",
            title: title,
            description: description,
            flag: flag,
            rawUrl: line,
            host: host,
            port: port,
            category: category,
          ));
        } catch (_) {}
      }
    }

    return servers.isEmpty ? getFallbackServers() : servers;
  }

  static List<VpnServer> getFallbackServers() {
    return [
      VpnServer(
        id: "auto_wifi",
        title: "🌐 Автоподбор WIFI",
        description: "Самые быстрые сервера",
        flag: "⚡",
        rawUrl: "vless://38d28b1d-8675-4e4c-80bc-ad2315bfb8cc@nl.tlsov.pro:443?type=tcp&security=reality&sni=vedomosti.ru&fp=qq&pbk=K42aHYxM9Lt1Tl4vF-OniHV5pNju-wnB_opA-hVihgs&sid=1000&spx=%2F&flow=xtls-rprx-vision",
        host: "nl.tlsov.pro",
        port: 443,
        category: "AUTO",
      ),
      VpnServer(
        id: "auto_lte",
        title: "🌐 Автоподбор LTE",
        description: "Самые быстрые сервера",
        flag: "⚡",
        rawUrl: "vless://402ced46-cf91-41f3-87a4-0a1a9e939a35@hole-nn.datanode-internal.net:443?type=grpc&security=reality&sni=ads.x5.ru&fp=qq&pbk=r6lN34m1nN-xQZ458j5NPD5xJ3_QBF2bGzY4KJEo4ic&sid=abbcd128&spx=%2F&serviceName=ads.x5.ru",
        host: "hole-nn.datanode-internal.net",
        port: 443,
        category: "AUTO",
      ),
    ];
  }
}

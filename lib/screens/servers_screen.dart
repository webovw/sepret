import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/vpn_service.dart';
import '../models/server_model.dart';

class ServersScreen extends StatelessWidget {
  const ServersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final vpn = Provider.of<VpnProvider>(context);

    final autoServers = vpn.servers.where((s) => s.category == 'AUTO').toList();
    final wifiServers = vpn.servers.where((s) => s.category == 'WIFI').toList();
    final lteServers  = vpn.servers.where((s) => s.category == 'LTE').toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.backgroundColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded, color: theme.textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Серверы и Локации",
                      style: TextStyle(color: theme.textColor, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.refresh_rounded, color: theme.secondaryAccent),
                      onPressed: () => vpn.pingAllServers(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    if (autoServers.isNotEmpty) ...[
                      _buildSectionHeader("АВТОПОДБОР (РЕКОМЕНДУЕТСЯ)", theme),
                      ...autoServers.map((s) => _buildServerCard(context, s, vpn, theme)),
                      const SizedBox(height: 16),
                    ],
                    if (wifiServers.isNotEmpty) ...[
                      _buildSectionHeader("ОСНОВНЫЕ СЕРВЕРЫ (ДЛЯ WIFI)", theme),
                      ...wifiServers.map((s) => _buildServerCard(context, s, vpn, theme)),
                      const SizedBox(height: 16),
                    ],
                    if (lteServers.isNotEmpty) ...[
                      _buildSectionHeader("ОБХОД БЛОКИРОВОК (ДЛЯ LTE)", theme),
                      ...lteServers.map((s) => _buildServerCard(context, s, vpn, theme)),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 4),
      child: Text(
        title,
        style: TextStyle(color: theme.subTextColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildServerCard(BuildContext context, VpnServer server, VpnProvider vpn, AppThemeData theme) {
    final isSelected = vpn.activeServer?.id == server.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () {
          vpn.selectServer(server);
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? theme.selectedCardColor : theme.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? theme.primaryAccent : Colors.white.withOpacity(0.05),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(server.flag, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      server.title,
                      style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      server.description,
                      style: TextStyle(color: isSelected ? theme.secondaryAccent : theme.subTextColor, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (server.ping > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: server.ping < 150 ? Colors.greenAccent.withOpacity(0.15) : Colors.orangeAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${server.ping} ms",
                    style: TextStyle(
                      color: server.ping < 150 ? Colors.greenAccent : Colors.orangeAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              if (isSelected)
                Icon(Icons.check_circle_rounded, color: theme.primaryAccent, size: 20)
              else
                Icon(Icons.radio_button_unchecked_rounded, color: theme.subTextColor.withOpacity(0.4), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

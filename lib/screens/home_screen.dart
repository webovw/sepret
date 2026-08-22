import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/vpn_service.dart';
import 'servers_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    return h == "00" ? "$m:$s" : "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final vpn = Provider.of<VpnProvider>(context);

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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.primaryAccent.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.shield_outlined, color: theme.secondaryAccent, size: 22),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "PHLUX VPN",
                          style: TextStyle(
                            color: theme.textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.settings_outlined, color: theme.textColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () => vpn.toggleConnection(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (vpn.isConnected)
                        Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryAccent.withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: vpn.isConnected ? theme.primaryAccent : theme.cardColor,
                          border: Border.all(
                            color: vpn.isConnected ? theme.secondaryAccent : theme.primaryAccent.withOpacity(0.4),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: vpn.isConnected ? theme.primaryAccent.withOpacity(0.5) : Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.power_settings_new_rounded,
                              size: 56,
                              color: vpn.isConnected ? Colors.white : theme.primaryAccent,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              vpn.state == VpnState.connected
                                  ? "ПОДКЛЮЧЕНО"
                                  : (vpn.state == VpnState.connecting ? "ПОДКЛЮЧЕНИЕ..." : "СТАРТ"),
                              style: TextStyle(
                                color: vpn.isConnected ? Colors.white : theme.subTextColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (vpn.isConnected)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.primaryAccent.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDuration(vpn.sessionDuration),
                        style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  "Защита отключена",
                  style: TextStyle(color: theme.subTextColor, fontSize: 13),
                ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_downward_rounded, color: theme.secondaryAccent, size: 20),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("СКАЧИВАНИЕ", style: TextStyle(color: theme.subTextColor, fontSize: 9, fontWeight: FontWeight.bold)),
                              Text("${vpn.downloadSpeed} KB/s", style: TextStyle(color: theme.textColor, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                      Container(width: 1, height: 28, color: Colors.white.withOpacity(0.1)),
                      Row(
                        children: [
                          Icon(Icons.arrow_upward_rounded, color: theme.primaryAccent, size: 20),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ОТДАЧА", style: TextStyle(color: theme.subTextColor, fontSize: 9, fontWeight: FontWeight.bold)),
                              Text("${vpn.uploadSpeed} KB/s", style: TextStyle(color: theme.textColor, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ServersScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.primaryAccent.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Text(vpn.activeServer?.flag ?? "🌐", style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vpn.activeServer?.title ?? "Выбрать сервер",
                                style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold, fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                vpn.activeServer?.description ?? "Автовыбор лучшего",
                                style: TextStyle(color: theme.secondaryAccent, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        if (vpn.activeServer?.ping != null && vpn.activeServer!.ping > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${vpn.activeServer!.ping} ms",
                              style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios_rounded, color: theme.subTextColor, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openSupportBot() async {
    final uri = Uri.parse("https://t.me/Phluxvpnbot");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.currentTheme;

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
                      "Настройки и Темы",
                      style: TextStyle(color: theme.textColor, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    _buildSectionTitle("ТЕМА ОФОРМЛЕНИЯ", theme),
                    _buildThemeCard(
                      context,
                      "🌌 Cosmic Space (PV Неон)",
                      "Глубокий индиго-космос под фирменный логотип",
                      ThemeType.cosmic,
                      themeProvider,
                      theme,
                      const [Color(0xFF0C1033), Color(0xFF0084FF)],
                    ),
                    _buildThemeCard(
                      context,
                      "⚪ White Luxury (Светлая)",
                      "Премиальный минимализм Apple с мягкими тенями",
                      ThemeType.white,
                      themeProvider,
                      theme,
                      const [Color(0xFFF4F6F9), Color(0xFF007AFF)],
                    ),
                    _buildThemeCard(
                      context,
                      "🌸 Pink Diamond (Розовая)",
                      "Бархатный тёмно-розовый гламур для девушек",
                      ThemeType.pink,
                      themeProvider,
                      theme,
                      const [Color(0xFF2E0B24), Color(0xFFFF2A8D)],
                    ),
                    _buildThemeCard(
                      context,
                      "🖤 OLED Pure Black (Чёрная)",
                      "Глубокий чёрный цвет для AMOLED экранов",
                      ThemeType.black,
                      themeProvider,
                      theme,
                      const [Color(0xFF000000), Color(0xFF1A1A1A)],
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle("СЕТЬ И РАСШИРЕНИЯ", theme),
                    _buildFeatureTile(
                      icon: Icons.account_balance_outlined,
                      title: "Раздельное туннелирование",
                      subtitle: "Банки РФ, Госуслуги и маркетплейсы идут напрямую",
                      value: true,
                      theme: theme,
                    ),
                    _buildFeatureTile(
                      icon: Icons.shield_moon_outlined,
                      title: "Kill Switch (Защита от утечек)",
                      subtitle: "Блокировать интернет при случайном разрыве VPN",
                      value: true,
                      theme: theme,
                    ),
                    const SizedBox(height: 20),
                    _buildSectionTitle("ПОДДЕРЖКА И СЕРВИС", theme),
                    GestureDetector(
                      onTap: _openSupportBot,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: theme.primaryAccent.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0088CC).withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.send_rounded, color: Color(0xFF0088CC), size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Бот поддержки в Telegram", style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text("@Phluxvpnbot", style: TextStyle(color: theme.secondaryAccent, fontSize: 12)),
                                ],
                              ),
                            ),
                            Icon(Icons.open_in_new_rounded, color: theme.subTextColor, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        "Phlux VPN Client • Версия 1.0.0 (Sing-box Core)",
                        style: TextStyle(color: theme.subTextColor, fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 6),
      child: Text(
        title,
        style: TextStyle(color: theme.subTextColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    String title,
    String subtitle,
    ThemeType type,
    ThemeProvider provider,
    AppThemeData theme,
    List<Color> previewColors,
  ) {
    final isSelected = provider.currentTheme.type == type;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => provider.setTheme(type),
        child: Container(
          padding: const EdgeInsets.all(14),
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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: previewColors),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(subtitle, style: TextStyle(color: isSelected ? theme.secondaryAccent : theme.subTextColor, fontSize: 11)),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle_rounded, color: theme.primaryAccent, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required AppThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.primaryAccent, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(subtitle, style: TextStyle(color: theme.subTextColor, fontSize: 10)),
                ],
              ),
            ),
            Switch(value: value, onChanged: (_) {}, activeColor: theme.primaryAccent),
          ],
        ),
      ),
    );
  }
}

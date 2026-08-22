import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { cosmic, black, white, pink }

class AppThemeData {
  final String name;
  final ThemeType type;
  final List<Color> backgroundColors;
  final Color cardColor;
  final Color selectedCardColor;
  final Color primaryAccent;
  final Color secondaryAccent;
  final Color textColor;
  final Color subTextColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final bool isDark;

  AppThemeData({
    required this.name,
    required this.type,
    required this.backgroundColors,
    required this.cardColor,
    required this.selectedCardColor,
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.textColor,
    required this.subTextColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.isDark,
  });
}

class AppThemes {
  // 1. Cosmic Space (под логотип PV)
  static final cosmic = AppThemeData(
    name: "Cosmic Space",
    type: ThemeType.cosmic,
    backgroundColors: [
      const Color(0xFF060814),
      const Color(0xFF0C1033),
      const Color(0xFF140D36),
    ],
    cardColor: const Color(0xFF0E1338).withOpacity(0.6),
    selectedCardColor: const Color(0xFF0084FF).withOpacity(0.25),
    primaryAccent: const Color(0xFF0084FF),
    secondaryAccent: const Color(0xFF00F0FF),
    textColor: const Color(0xFFE8F2FF),
    subTextColor: const Color(0xFF7E93B8),
    buttonColor: const Color(0xFF0084FF),
    buttonTextColor: Colors.white,
    isDark: true,
  );

  // 2. Pure Black OLED
  static final black = AppThemeData(
    name: "Pure OLED Black",
    type: ThemeType.black,
    backgroundColors: [
      const Color(0xFF000000),
      const Color(0xFF080808),
    ],
    cardColor: const Color(0xFF121212),
    selectedCardColor: const Color(0xFF242424),
    primaryAccent: const Color(0xFF00FFB3),
    secondaryAccent: Colors.white,
    textColor: Colors.white,
    subTextColor: const Color(0xFF888888),
    buttonColor: const Color(0xFF1A1A1A),
    buttonTextColor: Colors.white,
    isDark: true,
  );

  // 3. White Luxury Minimal
  static final white = AppThemeData(
    name: "White Luxury",
    type: ThemeType.white,
    backgroundColors: [
      const Color(0xFFF4F6F9),
      const Color(0xFFFFFFFF),
      const Color(0xFFEBF0F7),
    ],
    cardColor: Colors.white,
    selectedCardColor: const Color(0xFFE5F1FF),
    primaryAccent: const Color(0xFF007AFF),
    secondaryAccent: const Color(0xFF5AC8FA),
    textColor: const Color(0xFF1C1C1E),
    subTextColor: const Color(0xFF8E8E93),
    buttonColor: const Color(0xFF007AFF),
    buttonTextColor: Colors.white,
    isDark: false,
  );

  // 4. Pink Diamond Glamour
  static final pink = AppThemeData(
    name: "Pink Diamond",
    type: ThemeType.pink,
    backgroundColors: [
      const Color(0xFF190614),
      const Color(0xFF2E0B24),
      const Color(0xFF1F0719),
    ],
    cardColor: const Color(0xFF2A0A21).withOpacity(0.6),
    selectedCardColor: const Color(0xFFFF2A8D).withOpacity(0.25),
    primaryAccent: const Color(0xFFFF2A8D),
    secondaryAccent: const Color(0xFFFF70BA),
    textColor: const Color(0xFFFFF0F8),
    subTextColor: const Color(0xFFF29BCB),
    buttonColor: const Color(0xFFFF2A8D),
    buttonTextColor: Colors.white,
    isDark: true,
  );
}

class ThemeProvider extends ChangeNotifier {
  AppThemeData _currentTheme = AppThemes.cosmic;

  AppThemeData get currentTheme => _currentTheme;

  ThemeProvider() {
    _loadTheme();
  }

  void setTheme(ThemeType type) {
    switch (type) {
      case ThemeType.cosmic:
        _currentTheme = AppThemes.cosmic;
        break;
      case ThemeType.black:
        _currentTheme = AppThemes.black;
        break;
      case ThemeType.white:
        _currentTheme = AppThemes.white;
        break;
      case ThemeType.pink:
        _currentTheme = AppThemes.pink;
        break;
    }
    _saveTheme(type.index);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('theme_index') ?? 0;
    setTheme(ThemeType.values[index]);
  }

  Future<void> _saveTheme(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_index', index);
  }
}

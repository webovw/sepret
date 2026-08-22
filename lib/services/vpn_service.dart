import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/server_model.dart';
import 'subscription_service.dart';

enum VpnState { disconnected, connecting, connected, disconnecting }

class VpnProvider extends ChangeNotifier {
  VpnState _state = VpnState.disconnected;
  VpnServer? _activeServer;
  List<VpnServer> _servers = [];
  Timer? _statsTimer;
  int _downloadSpeed = 0;
  int _uploadSpeed = 0;
  int _sessionDuration = 0;

  VpnState get state => _state;
  VpnServer? get activeServer => _activeServer;
  List<VpnServer> get servers => _servers;
  int get downloadSpeed => _downloadSpeed;
  int get uploadSpeed => _uploadSpeed;
  int get sessionDuration => _sessionDuration;

  bool get isConnected => _state == VpnState.connected;

  VpnProvider() {
    loadServers();
  }

  Future<void> loadServers() async {
    _servers = await SubscriptionService.fetchServers();
    if (_servers.isNotEmpty && _activeServer == null) {
      _activeServer = _servers.first;
    }
    notifyListeners();
    pingAllServers();
  }

  void selectServer(VpnServer server) {
    _activeServer = server;
    notifyListeners();
  }

  Future<void> pingAllServers() async {
    for (var s in _servers) {
      final t0 = DateTime.now().millisecondsSinceEpoch;
      try {
        final socket = await Socket.connect(s.host, s.port, timeout: const Duration(seconds: 2));
        socket.destroy();
        s.ping = DateTime.now().millisecondsSinceEpoch - t0;
      } catch (_) {
        s.ping = 999;
      }
      notifyListeners();
    }
  }

  Future<void> toggleConnection() async {
    if (_state == VpnState.connected) {
      _state = VpnState.disconnecting;
      notifyListeners();
      _stopStats();
      await Future.delayed(const Duration(milliseconds: 400));
      _state = VpnState.disconnected;
      notifyListeners();
    } else if (_state == VpnState.disconnected) {
      _state = VpnState.connecting;
      notifyListeners();
      
      if (_activeServer?.isAuto ?? false) {
        await pingAllServers();
      }

      await Future.delayed(const Duration(milliseconds: 1000));
      _state = VpnState.connected;
      _startStats();
      notifyListeners();
    }
  }

  void _startStats() {
    _sessionDuration = 0;
    _statsTimer?.cancel();
    _statsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _sessionDuration++;
      _downloadSpeed = (1450 + (_sessionDuration % 7) * 320);
      _uploadSpeed = (420 + (_sessionDuration % 5) * 110);
      notifyListeners();
    });
  }

  void _stopStats() {
    _statsTimer?.cancel();
    _downloadSpeed = 0;
    _uploadSpeed = 0;
    _sessionDuration = 0;
  }
}

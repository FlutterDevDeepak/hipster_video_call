import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum ConnectivityStatus { online, offline, slowNetwork }

class ConnectivityHistory {
  final ConnectivityStatus? lastStatus;
  final ConnectivityStatus currentStatus;

  ConnectivityHistory({this.lastStatus, required this.currentStatus});
}

class ConnectivityService {
  int port = 443;
  Duration timeout = const Duration(seconds: 10);
  Timer? timer;
  ConnectivityStatus? _lastStatus;

  static List<InternetAddress> addresses = [
    InternetAddress('1.1.1.1'),
    InternetAddress('8.8.8.8'),
    InternetAddress('208.67.222.222')
  ];

  final _controller = StreamController<ConnectivityHistory>.broadcast();

  Stream<ConnectivityHistory> get connectionStatusStream =>
      _controller.stream;

  Future<bool> checkHostReachability(InternetAddress host) async {
    Socket? socket;
    try {
      socket = await Socket.connect(host, port, timeout: timeout);
      socket.destroy();
      return true;
    } catch (_) {
      socket?.destroy();
      return false;
    }
  }

  Future<bool> get isOnline async {
    if (kIsWeb) {
      return await isConnected;
    }
    final results = await Future.wait(addresses.map(checkHostReachability));
    return results.contains(true);
  }

  Future<bool> get isConnected async {
    final result = await Connectivity().checkConnectivity();
    return result[0] != ConnectivityResult.none;
  }

  Future<ConnectivityStatus> get connectivityStatus async {
    final online = await isOnline;
    final connected = await isConnected;
    if (online) return ConnectivityStatus.online;
    if (connected) return ConnectivityStatus.slowNetwork;
    return ConnectivityStatus.offline;
  }

  void startMonitoring() async {
    timer?.cancel();
    final status = await connectivityStatus;
    if (status != _lastStatus) {
      _controller.add(ConnectivityHistory(
        currentStatus: status,
        lastStatus: _lastStatus,
      ));
    }
    _lastStatus = status;
    timer = Timer(const Duration(seconds: 2), startMonitoring);
  }

  void dispose() {
    timer?.cancel();
    _controller.close();
  }
}

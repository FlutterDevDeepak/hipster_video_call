import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'connectivity_service.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  service.startMonitoring();
  ref.onDispose(() => service.dispose());
  return service;
});

final connectivityStreamProvider =
    StreamProvider<ConnectivityHistory>((ref) {
  return ref.watch(connectivityServiceProvider).connectionStatusStream;
});

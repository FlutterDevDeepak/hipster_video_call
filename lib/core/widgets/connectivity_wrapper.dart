import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/connectivity_service.dart';
import '../services/connectivity_provider.dart';

class ConnectivityWrapper extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onBackOnline;

  const ConnectivityWrapper({
    super.key,
    required this.child,
    this.onBackOnline,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityStreamProvider);

    return status.when(
      data: (history) {
        if ((history.lastStatus == ConnectivityStatus.offline ||
                history.lastStatus == ConnectivityStatus.slowNetwork) &&
            history.currentStatus == ConnectivityStatus.online) {
          onBackOnline?.call();
        }

        return Scaffold(
          body: Stack(
            children: [
              child,
              if (history.currentStatus == ConnectivityStatus.offline)
                const Align(
                  alignment: Alignment.topCenter,
                  child: OfflineBanner(),
                ),
               
            ],
          ),
        );
      },
      loading: () => child,
      error: (_, __) => child,
    );
  }
}

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      color: Colors.red,
      alignment: Alignment.center,
      child: const Text(
        'No Internet Connection',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}

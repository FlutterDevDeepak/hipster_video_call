import 'package:flutter/material.dart';
import 'package:hipster/core/routes/app_routes.dart';
import 'package:hipster/core/services/hive_init.dart';
import 'package:hipster/core/widgets/connectivity_wrapper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initHiveAndOpenBoxes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'HIPSTER',
        theme: ThemeData.dark(),
        builder: (context, child) {
          return ConnectivityWrapper(
            onBackOnline: () {
              debugPrint('We are back online!');
            },
            child: child!,
          );
        },
      ),
    );
  }
}



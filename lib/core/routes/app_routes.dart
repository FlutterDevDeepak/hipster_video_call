import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hipster/core/constants/route_name.dart';
import 'package:hipster/features/auth/views/pages/login_screen.dart';
import 'package:hipster/features/splash/presentation/pages/splash_screen.dart';
import 'package:hipster/features/users/views/user_list_view.dart';
import 'package:hipster/features/video_call/views/video_call_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteName.splash,
  routes: [
    GoRoute(
      path: RouteName.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(path: RouteName.login, builder: (context, state) => LoginScreen()),
    GoRoute(
      path: RouteName.videoCall,
      builder: (context, state) => VideoCallScreen(
        token:
            "",
        channelName: '',
      ),
    ),
    GoRoute(
      path: RouteName.userList,
      builder: (context, state) => UserListPage(),
    ),
  ],
  errorBuilder: (context, state) =>
      const Scaffold(body: Center(child: Text('Page not found'))),
);

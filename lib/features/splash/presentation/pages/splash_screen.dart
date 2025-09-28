import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hipster/core/constants/app_assets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    final scaleAnimation = useMemoized(() {
      return Tween<double>(
        begin: 0.2,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }, [controller]);

    useEffect(() {
      controller.forward();
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.go('/login');
        }
      });
      return null;
    }, [controller]);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ScaleTransition(
          scale: scaleAnimation,
          child: SvgPicture.network(AppAssets.logoUrl),
        ),
      ),
    );
  }
}

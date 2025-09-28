import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hipster/core/constants/app_assets.dart';
import 'package:hipster/core/constants/route_name.dart';
import 'package:hipster/core/services/call_kit_service.dart';
import 'package:hipster/core/services/permission_service.dart';
import 'package:hipster/core/widgets/my_common_buttons.dart';
import 'package:hipster/core/widgets/my_common_snackbar.dart';
import 'package:hipster/core/widgets/my_common_textfield.dart';
import 'package:hipster/features/auth/view_model/auth_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController(
      text: 'eve.holt@reqres.in',
    );
    final passwordController = useTextEditingController(text: 'cityslicka');
    final loginState = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);
    ref.listen<LoginState>(loginViewModelProvider, (prev, next) {
      final token = next.token;
      final error = next.error;

      if (token != null) {
        context.push(RouteName.videoCall);
      }
      if (error != null) {
        MycustomSnackbar.showSnackBar(context, error, isError: true);
      }
    });

    useEffect(() {
      CallKitService.instance.notificationPermission();
      CallKitService.instance.events.listen((e) {
        debugPrint('UI got event: ${e.event} => ${e.body}');
      });
      return null;
    }, []);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.network(
                      AppAssets.logoUrl,
                      height: 50,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20),
                    MyTextFormField(
                      controller: emailController,
                      label: "Enter your email",
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Email is required';
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value!)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    MyTextFormField(
                      controller: passwordController,
                      label: "Enter your password",
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    MyFilledButton(
                      isLoading: loginState.isLoading,
                      title: "Continue",
                      function: loginState.isLoading == true
                          ? null
                          : () async {
                              final permission =
                                  await PermissionService.ensureCameraAndMic();
                              if (!permission) {
                                await PermissionService.openAppSettingsIfPermanentlyDenied();
                              } else {
                                viewModel.login(
                                  emailController.text,
                                  passwordController.text,
                                );
                              }
                            },
                    ),
                    MyBorderButton(
                      borderColor: Colors.white,
                      title: "User List",
                      function: () {
                        context.push(RouteName.userList);
                      },
                    ),
                    MyBorderButton(
                      borderColor: Colors.green,
                      title: "Start call",
                      function: () async {
                        final permission =
                            await PermissionService.ensureNotifications();
                        if (permission) {
                          await CallKitService.instance.showIncoming(
                            nameCaller: 'Hipster Calling',
                            handle: '8434680104',
                            video: false,
                            extra: {'token': 'abc', "channel_name": "abc"},
                          );
                        } else {
                          await PermissionService.openAppSettingsIfPermanentlyDenied();
                        }
                      },
                    ),

                    MyBorderButton(
                      borderColor: Colors.red,
                      title: "End call",
                      function: () async {
                        CallKitService.instance.endAll();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

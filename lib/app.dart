
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/core/router/app_router.dart';
import 'package:nexus_app/core/theme/app_theme.dart';

class NexusApp extends ConsumerWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Nexus Pendant',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}

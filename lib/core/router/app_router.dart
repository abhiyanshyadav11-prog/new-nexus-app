
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/features/home/home_screen.dart';
import 'package:nexus_app/features/pendant/pendant_screen.dart';
import 'package:nexus_app/features/reminders/reminders_screen.dart';
import 'package:nexus_app/features/timetable/timetable_screen.dart';
import 'package:nexus_app/features/memory/memory_screen.dart';
import 'package:nexus_app/features/laptop/laptop_screen.dart';
import 'package:nexus_app/features/settings/settings_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/pendant',
        builder: (context, state) => const PendantScreen(),
      ),
      GoRoute(
        path: '/reminders',
        builder: (context, state) => const RemindersScreen(),
      ),
      GoRoute(
        path: '/timetable',
        builder: (context, state) => const TimetableScreen(),
      ),
      GoRoute(
        path: '/memory',
        builder: (context, state) => const MemoryScreen(),
      ),
      GoRoute(
        path: '/laptop',
        builder: (context, state) => const LaptopScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_app/core/constants/app_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildFeatureCard(context, AppStrings.pendantTitle, Icons.watch, '/pendant'),
            _buildFeatureCard(context, AppStrings.remindersTitle, Icons.alarm, '/reminders'),
            _buildFeatureCard(context, AppStrings.timetableTitle, Icons.calendar_today, '/timetable'),
            _buildFeatureCard(context, AppStrings.memoryTitle, Icons.memory, '/memory'),
            _buildFeatureCard(context, AppStrings.laptopTitle, Icons.laptop, '/laptop'),
            _buildFeatureCard(context, AppStrings.settingsTitle, Icons.settings, '/settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, String route) {
    return Card(
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

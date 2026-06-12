
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/core/constants/app_strings.dart';
import 'package:nexus_app/features/settings/settings_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _laptopAgentUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _laptopAgentUrlController.text = ref.read(settingsProvider).laptopAgentUrl ?? '';
  }

  @override
  void dispose() {
    _laptopAgentUrlController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final newUrl = _laptopAgentUrlController.text;
    if (Uri.tryParse(newUrl)?.isAbsolute == true) {
      ref.read(settingsProvider.notifier).setLaptopAgentUrl(newUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.settingsSaved)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.invalidUrl)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
           icon: const Icon(Icons.arrow_back),
           onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.settingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.laptopAgentUrl,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: _laptopAgentUrlController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., http://192.168.1.100:8000',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _saveSettings,
                      child: const Text(AppStrings.saveSettings),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.about,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    const Text(AppStrings.version),
                    const Text(AppStrings.developedBy),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

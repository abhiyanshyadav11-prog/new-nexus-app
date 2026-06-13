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
    _laptopAgentUrlController.text =
        ref.read(settingsProvider).laptopAgentUrl ?? '';
  }

  @override
  void dispose() {
    _laptopAgentUrlController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final newUrl = _laptopAgentUrlController.text;

    if (Uri.tryParse(newUrl)?.isAbsolute == true) {
      ref
          .read(settingsProvider.notifier)
          .setLaptopAgentUrl(newUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.settingsSaved),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.invalidUrl),
        ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // URL Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.laptopAgentUrl,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller:
                          _laptopAgentUrlController,
                      decoration:
                          const InputDecoration(
                        hintText:
                            'e.g., http://192.168.1.100:8000',
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveSettings,
                        child: const Text(
                          AppStrings.saveSettings,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // About Card
            const Card(
              child: Column(
                children: [
                  ListTile(
                    leading:
                        Icon(Icons.sell_outlined),
                    title: Text('Version'),
                    subtitle: Text('1.0.0'),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Icon(
                      Icons.business_outlined,
                    ),
                    title: Text('Built By'),
                    subtitle: Text('Trial Works'),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading:
                        Icon(Icons.auto_awesome),
                    title: Text('Nexus'),
                    subtitle: Text(
                      'Personal AI Assistant',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 48,
                    color: Colors.blueGrey,
                  ),

                  SizedBox(height: 8),

                  Text(
                    'NEXUS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    'Personal AI Companion',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
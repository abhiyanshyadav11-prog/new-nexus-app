import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/core/constants/app_strings.dart';
import 'package:nexus_app/features/laptop/laptop_provider.dart';
import 'package:go_router/go_router.dart';

class LaptopScreen extends ConsumerWidget {
  const LaptopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final laptopStatus = ref.watch(laptopProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.laptopTitle),
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
                      AppStrings.laptopAgentStatus,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    laptopStatus.when(
                      data: (status) => Text(
                        'Status: ${status['status']} (Platform: ${status['platform']})',
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('Error: $error'),
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        ref.read(laptopProvider.notifier).fetchStatus();
                      },
                      child: const Text('Refresh Status'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => ref
                      .read(laptopProvider.notifier)
                      .sendTestCommand(
                        'open_app',
                        {'app_name': 'Calculator'},
                      ),
                  child: const Text('Open Calculator'),
                ),

                ElevatedButton(
                  onPressed: () => ref
                      .read(laptopProvider.notifier)
                      .sendTestCommand(
                        'media_control',
                        {'action': 'play'},
                      ),
                  child: const Text('Media Play'),
                ),

                ElevatedButton(
                  onPressed: () => ref
                      .read(laptopProvider.notifier)
                      .sendTestCommand(
                        'media_control',
                        {'action': 'pause'},
                      ),
                  child: const Text('Media Pause'),
                ),

                ElevatedButton(
                  onPressed: () => ref
                      .read(laptopProvider.notifier)
                      .sendTestCommand(
                        'system_control',
                        {'action': 'volume_up'},
                      ),
                  child: const Text('Volume Up'),
                ),

                ElevatedButton(
                  onPressed: () => ref
                      .read(laptopProvider.notifier)
                      .sendTestCommand(
                        'system_control',
                        {'action': 'volume_down'},
                      ),
                  child: const Text('Volume Down'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
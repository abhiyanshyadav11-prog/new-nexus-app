import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/core/constants/app_strings.dart';
import 'package:nexus_app/features/pendant/pendant_provider.dart';
import 'package:nexus_app/services/ble_service.dart';

class PendantScreen extends ConsumerWidget {
  const PendantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleConnectionState =
        ref.watch(pendantConnectionStateProvider);
    final batteryLevel =
        ref.watch(pendantBatteryLevelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(AppStrings.pendantTitle),
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
                      AppStrings.bleStatus,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Status: ${bleConnectionState.when(
                        data: (state) => state.name,
                        loading: () => 'Loading...',
                        error: (_, __) => 'Error',
                      )}',
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton(
                          onPressed:
                              bleConnectionState.maybeWhen(
                            data: (state) =>
                                state ==
                                        BleConnectionState
                                            .disconnected
                                    ? () => ref
                                        .read(
                                          pendantProvider
                                              .notifier,
                                        )
                                        .scanAndConnect()
                                    : null,
                            orElse: () => null,
                          ),
                          child: const Text(
                            AppStrings.connectPendant,
                          ),
                        ),
                        ElevatedButton(
                          onPressed:
                              bleConnectionState.maybeWhen(
                            data: (state) =>
                                state ==
                                        BleConnectionState
                                            .connected
                                    ? () => ref
                                        .read(
                                          pendantProvider
                                              .notifier,
                                        )
                                        .disconnect()
                                    : null,
                            orElse: () => null,
                          ),
                          child: const Text(
                            AppStrings.disconnectPendant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.batteryLevel,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      batteryLevel.when(
                        data: (level) =>
                            level != null
                                ? '$level%'
                                : 'N/A',
                        loading: () => 'Loading...',
                        error: (_, __) => 'Error',
                      ),
                    ),
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
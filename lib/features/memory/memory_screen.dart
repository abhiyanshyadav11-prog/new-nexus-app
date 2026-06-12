
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/core/constants/app_strings.dart';
import 'package:nexus_app/core/utils/date_utils.dart' as nexus;
import 'package:nexus_app/data/models/memory_item.dart';
import 'package:nexus_app/features/memory/memory_provider.dart';
import 'package:go_router/go_router.dart';

class MemoryScreen extends ConsumerWidget {
  const MemoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoryItemsAsyncValue = ref.watch(memoryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.memoryTitle),
      ),
      body: memoryItemsAsyncValue.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(AppStrings.noMemoryItems),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(item.content),
                  subtitle: Text(nexus.DateUtils.formatDateTime(item.timestamp)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(memoryProvider.notifier).deleteMemoryItem(item.id!);
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMemoryItemDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMemoryItemDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.addMemoryItem),
          content: TextField(
            controller: contentController,
            decoration: const InputDecoration(labelText: 'Memory Content'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (contentController.text.isNotEmpty) {
                  final newItem = MemoryItem(
                    content: contentController.text,
                    timestamp: DateTime.now(),
                  );
                  ref.read(memoryProvider.notifier).addMemoryItem(newItem);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

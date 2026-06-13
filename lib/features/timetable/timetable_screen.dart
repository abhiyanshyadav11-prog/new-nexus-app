
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/core/constants/app_strings.dart';
import 'package:nexus_app/data/models/timetable_entry.dart';
import 'package:nexus_app/features/timetable/timetable_provider.dart';
import 'package:go_router/go_router.dart';

class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetableEntriesAsyncValue = ref.watch(timetableProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.timetableTitle),
      ),
      body: timetableEntriesAsyncValue.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Text(AppStrings.noTimetableEntries),
            );
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(entry.title),
                  subtitle: Text(
                      'Day: ${entry.dayOfWeek}, Time: ${entry.startTime} - ${entry.endTime}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref
                          .read(timetableProvider.notifier)
                          .deleteTimetableEntry(entry.id!);
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
          _showAddTimetableEntryDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTimetableEntryDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    int? selectedDay;
    final TextEditingController startTimeController = TextEditingController();
    final TextEditingController endTimeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.addTimetableEntry),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                DropdownButtonFormField<int>(
                  initialValue: selectedDay,
                  hint: const Text('Select Day of Week'),
                  items: List.generate(7, (index) => DropdownMenuItem(value: index, child: Text(_getDayName(index)))),
                  onChanged: (value) {
                    selectedDay = value;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a day';
                    }
                    return null;
                  },
                ),
                TextField(
                  controller: startTimeController,
                  decoration: const InputDecoration(labelText: 'Start Time (HH:MM)'),
                ),
                TextField(
                  controller: endTimeController,
                  decoration: const InputDecoration(labelText: 'End Time (HH:MM)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    selectedDay != null &&
                    startTimeController.text.isNotEmpty &&
                    endTimeController.text.isNotEmpty) {
                  final newEntry = TimetableEntry(
                    title: titleController.text,
                    dayOfWeek: selectedDay!,
                    startTime: startTimeController.text,
                    endTime: endTimeController.text,
                  );
                  ref
                      .read(timetableProvider.notifier)
                      .addTimetableEntry(newEntry);
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

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 0: return 'Monday';
      case 1: return 'Tuesday';
      case 2: return 'Wednesday';
      case 3: return 'Thursday';
      case 4: return 'Friday';
      case 5: return 'Saturday';
      case 6: return 'Sunday';
      default: return '';
    }
  }
}

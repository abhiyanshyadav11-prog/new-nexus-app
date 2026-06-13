import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/core/constants/app_strings.dart';
import 'package:nexus_app/features/laptop/laptop_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart';


class LaptopScreen extends ConsumerStatefulWidget {
const LaptopScreen({super.key});

@override
ConsumerState<LaptopScreen> createState() => _LaptopScreenState();
}

class _LaptopScreenState extends ConsumerState<LaptopScreen> {
final TextEditingController commandController =
TextEditingController();

String lastResponse = 'Ready';

final SpeechToText speech = SpeechToText();

bool isListening = false;
List<String> recentCommands = [];

@override
void dispose() {
speech.stop();
commandController.dispose();
super.dispose();

 void addToHistory(String command) {
  setState(() {
    recentCommands.insert(0, command);

    if (recentCommands.length > 5) {
      recentCommands.removeLast();
    }
  });
 }
}

Future<void> startListening() async {
  bool available = await speech.initialize();

  if (!available) return;

  setState(() {
    isListening = true;
  });

  speech.listen(
    onResult: (result) {
      setState(() {
        commandController.text =
            result.recognizedWords;
      });
    },
  );
}

@override
Widget build(BuildContext context) {
final laptopStatus = ref.watch(laptopProvider);


return Scaffold(
  appBar: AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => context.pop(),
    ),
    title: const Text(AppStrings.laptopTitle),
  ),
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
       // Status Card
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),  
    child: Row(
      children: [

        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 30,
          ),
        ),

        const SizedBox(width: 16),

        Flexible(
          child: laptopStatus.when(
            data: (status) => Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  ' Agent Status',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                 '${status['status']} • ${status['platform']}',
                 style: const TextStyle(
                   fontSize: 13,
                   color: Colors.grey,
                 ),
                ),
              ],
            ),

            loading: () => const Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Laptop Agent Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                CircularProgressIndicator(),
              ],
            ),

            error: (error, stack) => Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Laptop Agent Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Error: $error'),
              ],
            ),
          ),
        ),

        OutlinedButton.icon(
          onPressed: () {
            ref
                .read(laptopProvider.notifier)
                .fetchStatus();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh'),
        ),
      ],
    ),
  ),
),

const SizedBox(height: 16),

// Quick Actions
        Card(
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Quick Actions',
style: Theme.of(context).textTheme.titleMedium,
),
const SizedBox(height: 12),


    GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        Card(
          child: InkWell(
            onTap: () => ref
                .read(laptopProvider.notifier)
                .sendTestCommand(
                  'system_control',
                  {'action': 'lock'},
                ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 32),
                SizedBox(height: 8),
                Text('Lock PC'),
              ],
            ),
          ),
        ),

        Card(
          child: InkWell(
            onTap: () => ref
                .read(laptopProvider.notifier)
                .sendTestCommand(
                  'ai_command',
                  {'text': 'open chrome'},
                ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.web, size: 32),
                SizedBox(height: 8),
                Text('Chrome'),
              ],
            ),
          ),
        ),

        Card(
          child: InkWell(
            onTap: () => ref
                .read(laptopProvider.notifier)
                .sendTestCommand(
                  'ai_command',
                  {'text': 'open calculator'},
                ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calculate, size: 32),
                SizedBox(height: 8),
                Text('Calculator'),
              ],
            ),
          ),
        ),

        Card(
          child: InkWell(
            onTap: () => ref
                .read(laptopProvider.notifier)
                .sendTestCommand(
                  'audio_control',
                  {'level': 50},
                ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.volume_up, size: 32),
                SizedBox(height: 8),
                Text('Volume 50%'),
              ],
            ),
          ),
        ),
      ],
    ),
  ],
),


),
),


// AI Command
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Command',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium,
                ),

                const SizedBox(height: 12),

               TextField(
  controller: commandController,
  decoration: InputDecoration(
    hintText: 'Type any command',
    border: const OutlineInputBorder(),

    suffixIcon: IconButton(
      icon: Icon(
        isListening
            ? Icons.mic
            : Icons.mic_none,
      ),
      onPressed: startListening,
    ),
  ),
),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
  if (commandController.text.trim().isEmpty) {
    return;
  }

  final command = commandController.text.trim();


  ref
      .read(laptopProvider.notifier)
      .sendTestCommand(
        'ai_command',
        {
          'text': command,
        },
      );

  setState(() {
    lastResponse = 'Sent: $command';
  });

  commandController.clear();
},
                    child:
                        const Text('Execute'),
                  ),
                ),
                const SizedBox(height: 12),

Container(
  width: double.infinity,
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.green.shade50,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Colors.green.shade200,
    ),
  ),
  child: Row(
  children: [
    const Icon(
      Icons.check_circle,
      color: Colors.green,
    ),
    const SizedBox(width: 8),
    Expanded(
      child: Text(
        lastResponse,
      ),
    ),
  ],
),
  
),

const SizedBox(height: 16),

Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 12),

        if (recentCommands.isEmpty)
          const Text('No recent commands'),

        ...recentCommands.map(
          (command) => ListTile(
            dense: true,
            leading: const Icon(
              Icons.history,
              color: Colors.blue,
            ),
            title: Text(command),
          ),
        ),
      ],
    ),
  ),
),
              ],
            ),
          ),
        ),
        
// apps
        const SizedBox(height: 16),

        Card(
         child: ListTile(
          onTap: () {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
             content: Text('Apps coming soon'),
            ),
           );
          },
          leading: const Icon(Icons.apps),
          trailing: const Icon(Icons.chevron_right),
          title: const Text('Apps'),
          subtitle: const Text('Open and manage applications'),
         ),
        ),
//websites
        const SizedBox(height: 12),

        Card(
         child: ListTile(
          onTap: () {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
             content: Text('Websites coming soon'),
            ),
           );
          },
          leading: const Icon(Icons.language),
          trailing: const Icon(Icons.chevron_right),
          title: const Text('Websites'),
          subtitle: const Text('Open websites'),
         ),
        ),
      
//files
        const SizedBox(height: 12),

        Card(
         child: ListTile(
          onTap: () {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
             content: Text('Files coming soon'),
            ),
           );
          },
          leading: const Icon(Icons.folder),
          trailing: const Icon(Icons.chevron_right),
          title: const Text('Files'),
          subtitle: const Text('Find and open files'),
         ),
        ),

        const SizedBox(height: 16),

        
      ],
    ),
  ),
);
  }
}

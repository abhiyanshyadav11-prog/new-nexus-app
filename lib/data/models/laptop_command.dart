
class LaptopCommand {
  String command;
  Map<String, dynamic>? args;

  LaptopCommand({
    required this.command,
    this.args,
  });

  Map<String, dynamic> toJson() {
    return {
      'command': command,
      'args': args,
    };
  }

  factory LaptopCommand.fromJson(Map<String, dynamic> json) {
    return LaptopCommand(
      command: json['command'],
      args: json['args'] as Map<String, dynamic>?,
    );
  }
}

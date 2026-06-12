
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/core/utils/logger.dart';
import 'package:nexus_app/data/models/laptop_command.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final laptopApiServiceProvider = Provider<LaptopApiService>((ref) => LaptopApiService());

class LaptopApiService {
  String? _baseUrl;
  WebSocketChannel? _channel;

  LaptopApiService() {
    _loadBaseUrl();
  }

  Future<void> _loadBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    _baseUrl = prefs.getString('laptopAgentUrl');
    logger.i('Loaded Laptop Agent URL: $_baseUrl');
  }

  Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('laptopAgentUrl', url);
    _baseUrl = url;
    logger.i('Set Laptop Agent URL: $_baseUrl');
    _disconnectWebSocket();
    _connectWebSocket();
  }

  String? get baseUrl => _baseUrl;

  Future<Map<String, dynamic>> sendCommand(LaptopCommand command) async {
    if (_baseUrl == null || _baseUrl!.isEmpty) {
      return {'status': 'error', 'message': 'Laptop Agent URL not set.'};
    }

    final uri = Uri.parse('$_baseUrl/command');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(command.toJson()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'HTTP Error: ${response.statusCode}'};
      }
    } catch (e) {
      logger.e('Error sending command to laptop agent: $e');
      return {'status': 'error', 'message': 'Network Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getStatus() async {
    if (_baseUrl == null || _baseUrl!.isEmpty) {
      return {'status': 'error', 'message': 'Laptop Agent URL not set.'};
    }

    final uri = Uri.parse('$_baseUrl/status');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'HTTP Error: ${response.statusCode}'};
      }
    } catch (e) {
      logger.e('Error getting status from laptop agent: $e');
      return {'status': 'error', 'message': 'Network Error: $e'};
    }
  }

  void _connectWebSocket() {
    if (_baseUrl == null || _baseUrl!.isEmpty) return;

    try {
      final wsUrl = Uri.parse(_baseUrl!.replaceFirst('http', 'ws'));
      _channel = WebSocketChannel.connect(wsUrl);
      logger.i('WebSocket connected to $wsUrl');

      _channel!.stream.listen(
        (message) {
          logger.d('WebSocket message received: $message');
          // Handle incoming WebSocket messages (e.g., real-time status updates)
        },
        onDone: () {
          logger.w('WebSocket disconnected');
          _channel = null;
        },
        onError: (error) {
          logger.e('WebSocket error: $error');
          _channel = null;
        },
      );
    } catch (e) {
      logger.e('Error connecting WebSocket: $e');
    }
  }

  void _disconnectWebSocket() {
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    _disconnectWebSocket();
  }
}

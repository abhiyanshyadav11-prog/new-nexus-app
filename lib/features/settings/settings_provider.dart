
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexus_app/services/laptop_api_service.dart';

class SettingsState {
  final String? laptopAgentUrl;

  SettingsState({this.laptopAgentUrl});

  SettingsState copyWith({
    String? laptopAgentUrl,
  }) {
    return SettingsState(
      laptopAgentUrl: laptopAgentUrl ?? this.laptopAgentUrl,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref.read(laptopApiServiceProvider));
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  final LaptopApiService _laptopApiService;

  SettingsNotifier(this._laptopApiService) : super(SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('laptopAgentUrl');
    state = state.copyWith(laptopAgentUrl: url);
    _laptopApiService.setBaseUrl(url ?? '');
  }

  Future<void> setLaptopAgentUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('laptopAgentUrl', url);
    state = state.copyWith(laptopAgentUrl: url);
    _laptopApiService.setBaseUrl(url);
  }
}

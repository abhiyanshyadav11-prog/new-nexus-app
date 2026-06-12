
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_app/data/models/laptop_command.dart';
import 'package:nexus_app/services/laptop_api_service.dart';

final laptopRepositoryProvider = Provider<LaptopRepository>((ref) => LaptopRepository(ref.read(laptopApiServiceProvider)));

class LaptopRepository {
  final LaptopApiService _laptopApiService;

  LaptopRepository(this._laptopApiService);

  Future<Map<String, dynamic>> sendCommand(LaptopCommand command) async {
    return await _laptopApiService.sendCommand(command);
  }

  Future<Map<String, dynamic>> getStatus() async {
    return await _laptopApiService.getStatus();
  }
}

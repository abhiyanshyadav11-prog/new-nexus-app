
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleUuids {
  // Nexus Service UUID
  static final Guid NEXUS_SERVICE_UUID = Guid("12345678-1234-1234-1234-123456789ABC");

  // Characteristic UUIDs
  static final Guid AUDIO_DATA_CHAR_UUID = Guid("12345678-1234-1234-1234-123456789A01");
  static final Guid COMMAND_RX_CHAR_UUID = Guid("12345678-1234-1234-1234-123456789A02");
  static final Guid COMMAND_TX_CHAR_UUID = Guid("12345678-1234-1234-1234-123456789A03");
  static final Guid STATUS_CHAR_UUID = Guid("12345678-1234-1234-1234-123456789A04");
  static final Guid BATTERY_CHAR_UUID = Guid("12345678-1234-1234-1234-123456789A05");
}

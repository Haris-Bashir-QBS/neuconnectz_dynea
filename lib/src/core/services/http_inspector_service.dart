import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:neuconnectz_dynea/src/core/services/session_service.dart';

class HttpInspectorService {
  HttpInspectorService._internal();

  static final HttpInspectorService _instance =
      HttpInspectorService._internal();

  factory HttpInspectorService() => _instance;

  final Alice alice = Alice(
    configuration: AliceConfiguration(
      showNotification: true,
      showInspectorOnShake: true,
      navigatorKey: SessionManager.navigatorKey,
      notificationIcon: "@mipmap/ic_stat_dynea",
    ),
  );

  final AliceDioAdapter aliceDioAdapter = AliceDioAdapter();

  void setup() {
    alice.addAdapter(aliceDioAdapter);
  }
}

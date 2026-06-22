import 'package:dio/dio.dart';

import '../../constants/app_constants.dart';
import '../../storage/secure_storage.dart';

/// Attaches device and tenant identifiers to every request.
class DeviceInterceptor extends Interceptor {
  DeviceInterceptor({required SecureStorage secureStorage})
      : _secureStorage = secureStorage;

  final SecureStorage _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final deviceId = await _secureStorage.read(AppConstants.deviceIdKey);
    final tenantId = await _secureStorage.read(AppConstants.tenantIdKey);

    if (deviceId != null && deviceId.isNotEmpty) {
      options.headers['X-Device-Id'] = deviceId;
    }
    if (tenantId != null && tenantId.isNotEmpty) {
      options.headers['X-Tenant-Id'] = tenantId;
    }

    handler.next(options);
  }
}

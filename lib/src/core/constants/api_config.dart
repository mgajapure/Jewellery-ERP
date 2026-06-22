/// Central API configuration.
///
/// Update only this base URL to switch from mock data to the real backend.
/// The [MockInterceptor] is currently active and returns local mock responses.
/// When the backend is ready:
///   1. Change [baseUrl] to your real API (e.g. https://api.jewelleryerp.com/v1)
///   2. Remove [MockInterceptor] from [ApiClient] interceptors.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'https://api.example.com/v1';
  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// Toggle mock responses on/off.
  /// Set to false once the real backend is connected.
  static const bool useMockData = true;
}

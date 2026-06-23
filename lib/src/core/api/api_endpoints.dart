/// Central registry of all API endpoint paths.
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String requestOtp = '/auth/otp/request';
  static const String verifyOtp = '/auth/otp/verify';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Devices
  static const String devices = '/devices';

  // Customers
  static const String customers = '/customers';
  static String customerById(String id) => '/customers/$id';
  static const String customerSearch = '/customers/search';

  // Girvi
  static const String girvi = '/girvi';
  static String girviById(String id) => '/girvi/$id';
  static const String girviDue = '/girvi/due';
  static const String girviOverdue = '/girvi/overdue';
  static String girviPayment(String id) => '/girvi/$id/payment';
  static String girviRenewal(String id) => '/girvi/$id/renewal';
  static String girviRedemption(String id) => '/girvi/$id/redemption';
  static String girviAuction(String id) => '/girvi/$id/auction';

  // Dashboard
  static const String dashboardSummary = '/dashboard/summary';

  // Vault
  static const String vaults = '/vaults';
  static const String vaultAssign = '/vaults/assign';
}

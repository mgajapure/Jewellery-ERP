import 'dart:convert';

import 'package:dio/dio.dart';

import '../api_endpoints.dart';

/// Returns local mock responses for implemented endpoints.
///
/// This lets the app display realistic data without a backend.
/// When the real backend is ready, remove this interceptor from [ApiClient]
/// and update [ApiConfig.baseUrl].
class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final mock = _mockResponseFor(options.path, options.queryParameters);
    if (mock != null) {
      handler.resolve(
        Response(
          requestOptions: options,
          data: mock,
          statusCode: 200,
        ),
      );
      return;
    }

    handler.next(options);
  }

  dynamic _mockResponseFor(String path, Map<String, dynamic> query) {
    switch (path) {
      case ApiEndpoints.dashboardSummary:
        return {
          'success': true,
          'data': {
            'activeGirvi': 142,
            'dueToday': 8,
            'overdue': 3,
            'collectionsToday': 48500,
            'loanExposure': 2450000,
            'goldRate': 7850,
          },
        };

      case ApiEndpoints.customers:
        return {
          'success': true,
          'data': _customers,
        };

      case ApiEndpoints.customerSearch:
        final q = (query['q'] as String? ?? '').toLowerCase();
        final filtered = _customers.where((c) {
          final name = (c['name'] as String? ?? '').toLowerCase();
          final mobile = (c['mobile'] as String? ?? '').toLowerCase();
          return name.contains(q) || mobile.contains(q);
        }).toList();
        return {
          'success': true,
          'data': filtered,
        };

      default:
        // Girvi detail paths use regex pattern matching below.
        if (path.startsWith('${ApiEndpoints.customers}/')) {
          final id = path.split('/').last;
          final customer = _customers.firstWhere(
            (c) => c['id'] == id,
            orElse: () => <String, dynamic>{},
          );
          if (customer.isNotEmpty) {
            return {
              'success': true,
              'data': customer,
            };
          }
        }
        return null;
    }
  }

  static final List<Map<String, dynamic>> _customers = [
    {
      'id': 'cust-001',
      'tenantId': 'tenant-001',
      'digitalCustomerId': 'CUST-2026-000101',
      'name': 'सुरेश पाटील',
      'nameEn': 'Suresh Patil',
      'mobile': '+91 98765 43210',
      'alternateMobile': null,
      'address': '123 Shivaji Nagar, Pune',
      'aadhaarMasked': 'XXXX-XXXX-1234',
      'panNumber': 'ABCDE1234F',
      'dateOfBirth': '1985-06-15',
      'photoUrl': null,
      'qrCodeUrl': null,
      'riskCategory': 'LOW',
      'isActive': true,
      'activeGirvi': 2,
      'outstanding': 125000,
      'createdAt': '2026-01-10T08:30:00Z',
      'updatedAt': '2026-06-20T10:00:00Z',
      'version': 1,
    },
    {
      'id': 'cust-002',
      'tenantId': 'tenant-001',
      'digitalCustomerId': 'CUST-2026-000102',
      'name': 'मीना जाधव',
      'nameEn': 'Meena Jadhav',
      'mobile': '+91 87654 32109',
      'alternateMobile': null,
      'address': '45 FC Road, Pune',
      'aadhaarMasked': 'XXXX-XXXX-5678',
      'panNumber': 'FGHIJ5678K',
      'dateOfBirth': '1990-03-22',
      'photoUrl': null,
      'qrCodeUrl': null,
      'riskCategory': 'LOW',
      'isActive': true,
      'activeGirvi': 1,
      'outstanding': 45000,
      'createdAt': '2026-02-05T09:00:00Z',
      'updatedAt': '2026-06-18T11:30:00Z',
      'version': 1,
    },
    {
      'id': 'cust-003',
      'tenantId': 'tenant-001',
      'digitalCustomerId': 'CUST-2026-000103',
      'name': 'अमोल देशमुख',
      'nameEn': 'Amol Deshmukh',
      'mobile': '+91 76543 21098',
      'alternateMobile': null,
      'address': '78 Laxmi Road, Pune',
      'aadhaarMasked': 'XXXX-XXXX-9012',
      'panNumber': 'KLMNO9012P',
      'dateOfBirth': '1978-11-08',
      'photoUrl': null,
      'qrCodeUrl': null,
      'riskCategory': 'MEDIUM',
      'isActive': true,
      'activeGirvi': 3,
      'outstanding': 280000,
      'createdAt': '2026-01-20T10:15:00Z',
      'updatedAt': '2026-06-21T09:45:00Z',
      'version': 2,
    },
    {
      'id': 'cust-004',
      'tenantId': 'tenant-001',
      'digitalCustomerId': 'CUST-2026-000104',
      'name': 'सुनीता शिंदे',
      'nameEn': 'Sunita Shinde',
      'mobile': '+91 65432 10987',
      'alternateMobile': null,
      'address': '12 MG Road, Pune',
      'aadhaarMasked': 'XXXX-XXXX-3456',
      'panNumber': 'PQRST3456U',
      'dateOfBirth': '1982-07-30',
      'photoUrl': null,
      'qrCodeUrl': null,
      'riskCategory': 'LOW',
      'isActive': true,
      'activeGirvi': 0,
      'outstanding': 0,
      'createdAt': '2026-03-12T08:00:00Z',
      'updatedAt': '2026-06-15T16:20:00Z',
      'version': 1,
    },
    {
      'id': 'cust-005',
      'tenantId': 'tenant-001',
      'digitalCustomerId': 'CUST-2026-000105',
      'name': 'राजेंद्र कदम',
      'nameEn': 'Rajendra Kadam',
      'mobile': '+91 54321 09876',
      'alternateMobile': null,
      'address': '34 Karve Road, Pune',
      'aadhaarMasked': 'XXXX-XXXX-7890',
      'panNumber': 'UVWXY7890Z',
      'dateOfBirth': '1975-09-10',
      'photoUrl': null,
      'qrCodeUrl': null,
      'riskCategory': 'HIGH',
      'isActive': true,
      'activeGirvi': 2,
      'outstanding': 175000,
      'createdAt': '2026-01-28T11:00:00Z',
      'updatedAt': '2026-06-19T14:10:00Z',
      'version': 1,
    },
  ];
}

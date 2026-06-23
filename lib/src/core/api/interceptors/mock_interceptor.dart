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
    final mock = _mockResponseFor(
      options.path,
      options.method,
      options.queryParameters,
    );
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

  dynamic _mockResponseFor(
    String path,
    String method,
    Map<String, dynamic> query,
  ) {
    // POST endpoints — return success acknowledgement
    if (method == 'POST') {
      final postPaths = [
        RegExp(r'^/girvi/[^/]+/payment$'),
        RegExp(r'^/girvi/[^/]+/redemption$'),
        RegExp(r'^/girvi/[^/]+/auction$'),
      ];
      for (final pattern in postPaths) {
        if (pattern.hasMatch(path)) {
          return {'success': true, 'message': 'Operation completed.'};
        }
      }
      // Renewal returns updated girvi
      if (RegExp(r'^/girvi/[^/]+/renewal$').hasMatch(path)) {
        final id = path.split('/')[2];
        final girvi = _girviList.firstWhere(
          (g) => g['id'] == id || g['serialId'] == id,
          orElse: () => _girviList.first,
        );
        return {'success': true, 'data': girvi};
      }
    }

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
        return {'success': true, 'data': _customers};

      case ApiEndpoints.customerSearch:
        final q = (query['q'] as String? ?? '').toLowerCase();
        final filtered = _customers.where((c) {
          final name = (c['name'] as String? ?? '').toLowerCase();
          final mobile = (c['mobile'] as String? ?? '').toLowerCase();
          return name.contains(q) || mobile.contains(q);
        }).toList();
        return {'success': true, 'data': filtered};

      case ApiEndpoints.girvi:
        final statusFilter = query['status'] as String?;
        final searchQ = (query['q'] as String? ?? '').toLowerCase();
        var list = _girviList.toList();
        if (statusFilter != null && statusFilter.isNotEmpty) {
          list = list
              .where((g) => g['status'] == statusFilter)
              .toList();
        }
        if (searchQ.isNotEmpty) {
          list = list.where((g) {
            final name = (g['customerName'] as String? ?? '').toLowerCase();
            final nameEn =
                (g['customerNameEn'] as String? ?? '').toLowerCase();
            final serial = (g['serialId'] as String? ?? '').toLowerCase();
            return name.contains(searchQ) ||
                nameEn.contains(searchQ) ||
                serial.contains(searchQ);
          }).toList();
        }
        return {'success': true, 'data': list};

      case ApiEndpoints.girviDue:
        final due = _girviList
            .where(
              (g) =>
                  (g['daysLeft'] as int) >= 0 &&
                  (g['daysLeft'] as int) <= 7 &&
                  g['status'] == 'active',
            )
            .toList();
        return {'success': true, 'data': due};

      case ApiEndpoints.girviOverdue:
        final overdue = _girviList
            .where((g) => g['status'] == 'overdue')
            .toList();
        return {'success': true, 'data': overdue};

      default:
        if (path.startsWith('${ApiEndpoints.customers}/')) {
          final id = path.split('/').last;
          final customer = _customers.firstWhere(
            (c) => c['id'] == id,
            orElse: () => <String, dynamic>{},
          );
          if (customer.isNotEmpty) {
            return {'success': true, 'data': customer};
          }
        }

        if (path.startsWith('${ApiEndpoints.girvi}/')) {
          final id = path.split('/')[2];
          final girvi = _girviList.firstWhere(
            (g) => g['id'] == id || g['serialId'] == id,
            orElse: () => <String, dynamic>{},
          );
          if (girvi.isNotEmpty) {
            return {'success': true, 'data': girvi};
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

  static final List<Map<String, dynamic>> _girviList = [
    {
      'id': 'grv-001',
      'serialId': 'GRV-2026-000521',
      'tenantId': 'tenant-001',
      'customerId': 'cust-001',
      'customerName': 'सुरेश पाटील',
      'customerNameEn': 'Suresh Patil',
      'customerMobile': '+91 98765 43210',
      'status': 'active',
      'loanAmount': 75000.0,
      'outstandingAmount': 82450.0,
      'accruedInterest': 7450.0,
      'penaltyAmount': 0.0,
      'interestRate': 18.0,
      'interestType': 'simple',
      'penaltyRate': 2.0,
      'startDate': '2026-05-15T00:00:00Z',
      'dueDate': '2026-07-15T00:00:00Z',
      'daysLeft': 22,
      'vaultLocation': 'VA-A/SF-02/TR-05/SL-18',
      'kfsDocUrl': null,
      'createdAt': '2026-05-15T10:00:00Z',
      'updatedAt': '2026-06-20T10:00:00Z',
      'version': 1,
      'items': [
        {
          'id': 'item-001',
          'description': '22K सोन्याची चेन',
          'itemType': 'Chain',
          'quantity': 1,
          'grossWeightG': 15.5,
          'stoneWeightG': 0.0,
          'netWeightG': 15.5,
          'purity': '22K',
          'metalType': 'gold',
          'valuationAmount': 110000.0,
          'photoUrls': [],
        },
        {
          'id': 'item-002',
          'description': '22K सोन्याची अंगठी',
          'itemType': 'Ring',
          'quantity': 1,
          'grossWeightG': 5.2,
          'stoneWeightG': 0.5,
          'netWeightG': 4.7,
          'purity': '22K',
          'metalType': 'gold',
          'valuationAmount': 33000.0,
          'photoUrls': [],
        },
      ],
      'payments': [],
    },
    {
      'id': 'grv-002',
      'serialId': 'GRV-2026-000520',
      'tenantId': 'tenant-001',
      'customerId': 'cust-002',
      'customerName': 'मीना जाधव',
      'customerNameEn': 'Meena Jadhav',
      'customerMobile': '+91 87654 32109',
      'status': 'partialPaid',
      'loanAmount': 50000.0,
      'outstandingAmount': 28000.0,
      'accruedInterest': 3000.0,
      'penaltyAmount': 0.0,
      'interestRate': 18.0,
      'interestType': 'simple',
      'penaltyRate': 2.0,
      'startDate': '2026-05-20T00:00:00Z',
      'dueDate': '2026-07-20T00:00:00Z',
      'daysLeft': 27,
      'vaultLocation': 'VA-A/SF-01/TR-03/SL-07',
      'kfsDocUrl': null,
      'createdAt': '2026-05-20T11:30:00Z',
      'updatedAt': '2026-06-15T09:00:00Z',
      'version': 2,
      'items': [
        {
          'id': 'item-003',
          'description': '22K मंगळसूत्र',
          'itemType': 'Mangalsutra',
          'quantity': 1,
          'grossWeightG': 10.0,
          'stoneWeightG': 0.0,
          'netWeightG': 10.0,
          'purity': '22K',
          'metalType': 'gold',
          'valuationAmount': 71850.0,
          'photoUrls': [],
        },
      ],
      'payments': [
        {
          'id': 'pay-001',
          'amount': 22000.0,
          'principalPaid': 18000.0,
          'interestPaid': 4000.0,
          'paymentType': 'cash',
          'paidAt': '2026-06-15T10:00:00Z',
          'referenceNumber': null,
          'notes': null,
        },
      ],
    },
    {
      'id': 'grv-003',
      'serialId': 'GRV-2026-000519',
      'tenantId': 'tenant-001',
      'customerId': 'cust-003',
      'customerName': 'अमोल देशमुख',
      'customerNameEn': 'Amol Deshmukh',
      'customerMobile': '+91 76543 21098',
      'status': 'overdue',
      'loanAmount': 120000.0,
      'outstandingAmount': 138500.0,
      'accruedInterest': 14000.0,
      'penaltyAmount': 4500.0,
      'interestRate': 18.0,
      'interestType': 'simple',
      'penaltyRate': 2.0,
      'startDate': '2026-03-01T00:00:00Z',
      'dueDate': '2026-06-01T00:00:00Z',
      'daysLeft': -22,
      'vaultLocation': 'VA-B/SF-03/TR-01/SL-12',
      'kfsDocUrl': null,
      'createdAt': '2026-03-01T09:00:00Z',
      'updatedAt': '2026-06-01T00:00:00Z',
      'version': 1,
      'items': [
        {
          'id': 'item-004',
          'description': '22K सोन्याचे कडे',
          'itemType': 'Bangle',
          'quantity': 2,
          'grossWeightG': 25.0,
          'stoneWeightG': 0.0,
          'netWeightG': 25.0,
          'purity': '22K',
          'metalType': 'gold',
          'valuationAmount': 90000.0,
          'photoUrls': [],
        },
        {
          'id': 'item-005',
          'description': '22K नेकलेस',
          'itemType': 'Necklace',
          'quantity': 1,
          'grossWeightG': 18.0,
          'stoneWeightG': 1.0,
          'netWeightG': 17.0,
          'purity': '22K',
          'metalType': 'gold',
          'valuationAmount': 60000.0,
          'photoUrls': [],
        },
        {
          'id': 'item-006',
          'description': 'सोन्याचे नाणे',
          'itemType': 'Coin',
          'quantity': 1,
          'grossWeightG': 8.0,
          'stoneWeightG': 0.0,
          'netWeightG': 8.0,
          'purity': '24K',
          'metalType': 'gold',
          'valuationAmount': 22500.0,
          'photoUrls': [],
        },
      ],
      'payments': [],
    },
    {
      'id': 'grv-004',
      'serialId': 'GRV-2026-000518',
      'tenantId': 'tenant-001',
      'customerId': 'cust-004',
      'customerName': 'सुनीता शिंदे',
      'customerNameEn': 'Sunita Shinde',
      'customerMobile': '+91 65432 10987',
      'status': 'redeemed',
      'loanAmount': 35000.0,
      'outstandingAmount': 0.0,
      'accruedInterest': 0.0,
      'penaltyAmount': 0.0,
      'interestRate': 18.0,
      'interestType': 'simple',
      'penaltyRate': 2.0,
      'startDate': '2026-04-10T00:00:00Z',
      'dueDate': '2026-05-10T00:00:00Z',
      'daysLeft': 0,
      'vaultLocation': 'VA-A/SF-01/TR-02/SL-04',
      'kfsDocUrl': null,
      'createdAt': '2026-04-10T08:30:00Z',
      'updatedAt': '2026-05-08T15:00:00Z',
      'version': 2,
      'items': [
        {
          'id': 'item-007',
          'description': '22K ब्रेसलेट',
          'itemType': 'Bracelet',
          'quantity': 1,
          'grossWeightG': 7.5,
          'stoneWeightG': 0.0,
          'netWeightG': 7.5,
          'purity': '22K',
          'metalType': 'gold',
          'valuationAmount': 50000.0,
          'photoUrls': [],
        },
      ],
      'payments': [
        {
          'id': 'pay-002',
          'amount': 36050.0,
          'principalPaid': 35000.0,
          'interestPaid': 1050.0,
          'paymentType': 'upi',
          'paidAt': '2026-05-08T15:00:00Z',
          'referenceNumber': 'UPI-20260508-001',
          'notes': 'Full redemption',
        },
      ],
    },
    {
      'id': 'grv-005',
      'serialId': 'GRV-2026-000517',
      'tenantId': 'tenant-001',
      'customerId': 'cust-005',
      'customerName': 'राजेंद्र कदम',
      'customerNameEn': 'Rajendra Kadam',
      'customerMobile': '+91 54321 09876',
      'status': 'renewed',
      'loanAmount': 200000.0,
      'outstandingAmount': 218000.0,
      'accruedInterest': 18000.0,
      'penaltyAmount': 0.0,
      'interestRate': 18.0,
      'interestType': 'simple',
      'penaltyRate': 2.0,
      'startDate': '2026-04-10T00:00:00Z',
      'dueDate': '2026-08-10T00:00:00Z',
      'daysLeft': 48,
      'vaultLocation': 'VA-B/SF-02/TR-04/SL-09',
      'kfsDocUrl': null,
      'createdAt': '2026-01-10T10:00:00Z',
      'updatedAt': '2026-04-10T11:00:00Z',
      'version': 3,
      'items': [
        {
          'id': 'item-008',
          'description': '22K सोन्याचे कडे',
          'itemType': 'Bangle',
          'quantity': 2,
          'grossWeightG': 30.0,
          'stoneWeightG': 0.0,
          'netWeightG': 30.0,
          'purity': '22K',
          'metalType': 'gold',
          'valuationAmount': 107000.0,
          'photoUrls': [],
        },
        {
          'id': 'item-009',
          'description': '22K चेन',
          'itemType': 'Chain',
          'quantity': 1,
          'grossWeightG': 20.0,
          'stoneWeightG': 0.0,
          'netWeightG': 20.0,
          'purity': '22K',
          'metalType': 'gold',
          'valuationAmount': 143700.0,
          'photoUrls': [],
        },
        {
          'id': 'item-010',
          'description': '22K पेंडेंट',
          'itemType': 'Pendant',
          'quantity': 1,
          'grossWeightG': 5.0,
          'stoneWeightG': 0.5,
          'netWeightG': 4.5,
          'purity': '22K',
          'metalType': 'gold',
          'valuationAmount': 32000.0,
          'photoUrls': [],
        },
        {
          'id': 'item-011',
          'description': '22K अंगठी',
          'itemType': 'Ring',
          'quantity': 1,
          'grossWeightG': 4.0,
          'stoneWeightG': 0.2,
          'netWeightG': 3.8,
          'purity': '22K',
          'metalType': 'gold',
          'valuationAmount': 27000.0,
          'photoUrls': [],
        },
      ],
      'payments': [],
    },
  ];
}

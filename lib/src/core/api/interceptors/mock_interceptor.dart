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
    final mock = _mockResponseFor(options);
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

  static Map<String, dynamic>? _extractBody(RequestOptions options) {
    final data = options.data;
    if (data is Map<String, dynamic>) return data;
    return null;
  }

  dynamic _mockResponseFor(RequestOptions options) {
    final path = options.path;
    final method = options.method;
    final query = options.queryParameters;
    // POST endpoints — return success acknowledgement
    if (method == 'POST') {
      // Auth — request OTP
      if (path == ApiEndpoints.requestOtp) {
        return {
          'success': true,
          'data': {
            'requestId': 'otp-req-${DateTime.now().millisecondsSinceEpoch}',
          },
        };
      }

      // Auth — verify OTP
      // Rules: '000000' → registration pending; any other 6-digit OTP → success.
      if (path == ApiEndpoints.verifyOtp) {
        final otp = (_extractBody(options)?['otp'] as String?) ?? '';
        if (otp == '000000') {
          return {
            'success': false,
            'pending': true,
            'message': 'Device registration is pending admin approval.',
          };
        }
        return {
          'success': true,
          'data': {
            'accessToken':
                'mock-access-${DateTime.now().millisecondsSinceEpoch}',
            'refreshToken': 'mock-refresh-token',
            'staffId': 'staff-001',
            'tenantId': 'tenant-001',
            'staffName': 'रमेश पाटील / Ramesh Patil',
            'role': 'STAFF',
            'expiresAt': DateTime.now()
                .add(const Duration(hours: 8))
                .toIso8601String(),
          },
        };
      }

      // Auth — refresh token → return a refreshed session
      if (path == ApiEndpoints.refreshToken) {
        return {
          'success': true,
          'data': {
            'accessToken':
                'mock-access-refreshed-${DateTime.now().millisecondsSinceEpoch}',
            'refreshToken': 'mock-refresh-token-2',
            'staffId': 'staff-001',
            'tenantId': 'tenant-001',
            'staffName': 'रमेश पाटील / Ramesh Patil',
            'role': 'STAFF',
            'expiresAt': DateTime.now()
                .add(const Duration(hours: 8))
                .toIso8601String(),
          },
        };
      }

      // Auth — logout → always success
      if (path == ApiEndpoints.logout) {
        return {'success': true};
      }

      // Purchase — create new purchase entry
      if (path == ApiEndpoints.purchases) {
        final body = _extractBody(options) ?? {};
        final now = DateTime.now();
        final id =
            'PUR-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${(1000 + _purchaseLedger.length).toString()}';
        final entry = {
          'id': id,
          'date': now.toIso8601String(),
          'supplierName': body['supplierName'] ?? 'Unknown',
          'supplierMobile': body['supplierMobile'] ?? '',
          'billNo': body['billNo'] ?? '',
          'purchaseType': body['purchaseType'] ?? 'NEWINVENTORY',
          'metalType': body['metalType'] ?? 'GOLD22K',
          'itemName': body['itemName'] ?? '',
          'grossWeight': body['grossWeight'] ?? 0.0,
          'netWeight': body['netWeight'] ?? 0.0,
          'purity': body['purity'] ?? 0.0,
          'rate': body['rate'] ?? 0.0,
          'amount': body['amount'] ?? 0.0,
          'gst': 0.0,
          'totalAmount': body['amount'] ?? 0.0,
          'paymentMode': body['paymentMode'] ?? 'CASH',
          'status': 'PENDING',
        };
        return {'success': true, 'data': entry};
      }

      // Vault — assign slot
      if (path == ApiEndpoints.vaultAssign) {
        final coordinate =
            (_extractBody(options)?['coordinate'] as String?) ?? '';
        return {
          'success': true,
          'data': {'coordinate': coordinate},
        };
      }

      // Customer creation — simulate a new customer record
      if (path == ApiEndpoints.customers) {
        final now = DateTime.now().toIso8601String();
        final newId = 'cust-${DateTime.now().millisecondsSinceEpoch}';
        return {
          'success': true,
          'data': {
            'id': newId,
            'tenantId': 'tenant-001',
            'digitalCustomerId':
                'CUST-2026-${(1000 + _customers.length).toString().padLeft(6, '0')}',
            'name': '—',
            'nameEn': 'New Customer',
            'mobile': '+91 00000 00000',
            'alternateMobile': null,
            'address': '',
            'aadhaarMasked': null,
            'panNumber': null,
            'dateOfBirth': null,
            'photoUrl': null,
            'qrCodeUrl': null,
            'riskCategory': 'LOW',
            'isActive': true,
            'activeGirvi': 0,
            'outstanding': 0,
            'createdAt': now,
            'updatedAt': now,
            'version': 1,
          },
        };
      }

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
      case ApiEndpoints.vaults:
        return {'success': true, 'data': _vaultOccupancy};

      case ApiEndpoints.vaultList:
        return {'success': true, 'data': ['Vault-A', 'Vault-B', 'Vault-C']};

      case ApiEndpoints.vaultSearch:
        final q = (query['q'] as String? ?? '').toLowerCase();
        final filtered = _vaultSearchResults.where((r) {
          return (r['customerName'] as String).toLowerCase().contains(q) ||
              (r['girviId'] as String).toLowerCase().contains(q) ||
              (r['mobile'] as String).contains(q) ||
              (r['serialId'] as String).toLowerCase().contains(q);
        }).toList();
        return {'success': true, 'data': filtered};

      case ApiEndpoints.purchaseDashboard:
        return {'success': true, 'data': _purchaseDashboardStats};

      case ApiEndpoints.purchaseLedger:
        final payFilter = (query['filter'] as String? ?? '').toUpperCase();
        final searchQ = (query['q'] as String? ?? '').toLowerCase();
        var ledger = _purchaseLedger.toList();
        if (payFilter.isNotEmpty) {
          ledger = ledger.where((e) {
            if (payFilter == 'CASH') return e['paymentMode'] == 'CASH';
            if (payFilter == 'BANK') return e['paymentMode'] == 'BANK_TRANSFER';
            if (payFilter == 'CREDIT') return e['paymentMode'] == 'CREDIT';
            return true;
          }).toList();
        }
        if (searchQ.isNotEmpty) {
          ledger = ledger.where((e) {
            return (e['supplierName'] as String)
                    .toLowerCase()
                    .contains(searchQ) ||
                (e['id'] as String).toLowerCase().contains(searchQ);
          }).toList();
        }
        return {'success': true, 'data': ledger};

      case ApiEndpoints.suppliers:
        final suppFilter = (query['filter'] as String? ?? '').toUpperCase();
        final suppQ = (query['q'] as String? ?? '').toLowerCase();
        var suppList = _suppliers.toList();
        if (suppFilter.isNotEmpty) {
          suppList = suppList
              .where((s) => s['status'] == suppFilter)
              .toList();
        }
        if (suppQ.isNotEmpty) {
          suppList = suppList.where((s) {
            return (s['name'] as String).toLowerCase().contains(suppQ) ||
                (s['mobile'] as String).contains(suppQ);
          }).toList();
        }
        return {'success': true, 'data': suppList};

      case ApiEndpoints.dashboardSummary:
        return {
          'success': true,
          'data': {
            'activeGirvi': 142,
            'dueToday': 8,
            'overdue': 3,
            'collectionsToday': 48500.0,
            'loanExposure': 2450000.0,
            'goldRatePerGram': 7185.0,
            'goldRateChange': 32.0,
            'goldRateChangePct': 0.45,
            'goldRateSource': 'MCX',
            'goldRateUpdatedAt': '2026-06-23T09:30:00Z',
            'newGirviToday': 3,
            'disbursedToday': 186000.0,
            'recentPayments': [
              {
                'id': 'rp-001',
                'customerName': 'सुरेश पाटील',
                'customerNameEn': 'Suresh Patil',
                'girviSerial': 'GRV-2026-000521',
                'paymentType': 'interest',
                'amount': 12500.0,
                'paidAt': '2026-06-23T10:45:00Z',
              },
              {
                'id': 'rp-002',
                'customerName': 'मीना जाधव',
                'customerNameEn': 'Meena Jadhav',
                'girviSerial': 'GRV-2026-000520',
                'paymentType': 'principal',
                'amount': 35000.0,
                'paidAt': '2026-06-23T09:20:00Z',
              },
              {
                'id': 'rp-003',
                'customerName': 'अमोल देशमुख',
                'customerNameEn': 'Amol Deshmukh',
                'girviSerial': 'GRV-2026-000519',
                'paymentType': 'partial',
                'amount': 8760.0,
                'paidAt': '2026-06-22T16:30:00Z',
              },
              {
                'id': 'rp-004',
                'customerName': 'राजेंद्र कदम',
                'customerNameEn': 'Rajendra Kadam',
                'girviSerial': 'GRV-2026-000517',
                'paymentType': 'renewal',
                'amount': 200000.0,
                'paidAt': '2026-06-22T11:00:00Z',
              },
            ],
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

        if (path.startsWith('/purchases/')) {
          final segments = path.split('/');
          if (segments.length == 3) {
            final id = segments[2];
            final entry = _purchaseLedger.firstWhere(
              (e) => e['id'] == id,
              orElse: () => _purchaseLedger.first,
            );
            return {'success': true, 'data': entry};
          }
        }

        if (path.startsWith('/interest/ledger/')) {
          return {'success': true, 'data': _interestLedger};
        }

        // Vault structure: /vaults/{vault}/safes/{safe}/trays/{tray}/slots
        final vaultSlotRe =
            RegExp(r'^/vaults/([^/]+)/safes/([^/]+)/trays/([^/]+)/slots$');
        final vaultSlotMatch = vaultSlotRe.firstMatch(path);
        if (vaultSlotMatch != null) {
          final vault = vaultSlotMatch.group(1)!;
          final safe = vaultSlotMatch.group(2)!;
          final tray = vaultSlotMatch.group(3)!;
          return {
            'success': true,
            'data': _buildSlots(vault, safe, tray),
          };
        }

        // Vault structure: /vaults/{vault}/safes/{safe}/trays
        final vaultTrayRe = RegExp(r'^/vaults/([^/]+)/safes/([^/]+)/trays$');
        if (vaultTrayRe.hasMatch(path)) {
          return {
            'success': true,
            'data': ['Tray-01', 'Tray-05', 'Tray-12'],
          };
        }

        // Vault structure: /vaults/{vault}/safes
        final vaultSafeRe = RegExp(r'^/vaults/([^/]+)/safes$');
        if (vaultSafeRe.hasMatch(path)) {
          return {
            'success': true,
            'data': ['Safe-01', 'Safe-02', 'Safe-03'],
          };
        }

        return null;
    }
  }

  static List<Map<String, dynamic>> _buildSlots(
    String vault,
    String safe,
    String tray,
  ) {
    final vaultCode = vault.replaceAll('Vault-', 'VA-');
    final safeCode = safe.replaceAll('Safe-', 'SF-');
    final trayCode = tray.replaceAll('Tray-', 'TR-');
    final occupied = {'SL-02', 'SL-05', 'SL-09', 'SL-14', 'SL-18'};
    final reserved = {'SL-20'};
    return List.generate(20, (i) {
      final n = (i + 1).toString().padLeft(2, '0');
      final slotCode = 'SL-$n';
      final coord = '$vaultCode/$safeCode/$trayCode/$slotCode';
      final status = occupied.contains(slotCode)
          ? 'occupied'
          : reserved.contains(slotCode)
              ? 'reserved'
              : 'available';
      final girviId = occupied.contains(slotCode) ? 'GRV-2026-0005$n' : null;
      return {
        'id': 'slot-${coord.replaceAll('/', '-').toLowerCase()}',
        'slotName': 'Slot-$n',
        'coordinate': coord,
        'status': status,
        'girviId': girviId,
      };
    });
  }

  static final Map<String, dynamic> _purchaseDashboardStats = {
    'todayPurchases': 8,
    'todayValue': 420000.0,
    'pendingApprovals': 3,
    'totalSuppliers': 24,
    'scrapPurchases': 5,
    'inventoryAdded': 12,
  };

  static final List<Map<String, dynamic>> _purchaseLedger = [
    {
      'id': 'PUR-20250622-001',
      'date': '2025-06-22T00:00:00Z',
      'supplierName': 'Ramesh Jewellers',
      'supplierMobile': '+91 98765 43210',
      'billNo': 'BJ/2025/045',
      'purchaseType': 'NEWINVENTORY',
      'metalType': 'GOLD22K',
      'itemName': 'Gold Chain',
      'grossWeight': 26.10,
      'netWeight': 24.50,
      'purity': 91.6,
      'rate': 5102.0,
      'amount': 124999.0,
      'gst': 1.0,
      'totalAmount': 125000.0,
      'paymentMode': 'BANK_TRANSFER',
      'status': 'APPROVED',
    },
    {
      'id': 'PUR-20250621-002',
      'date': '2025-06-21T00:00:00Z',
      'supplierName': 'Shree Gold House',
      'supplierMobile': '+91 91234 56789',
      'billNo': 'SGH/2025/012',
      'purchaseType': 'SCRAP',
      'metalType': 'GOLD22K',
      'itemName': 'Gold Scrap',
      'grossWeight': 8.50,
      'netWeight': 8.20,
      'purity': 91.6,
      'rate': 5122.0,
      'amount': 42000.0,
      'gst': 0.0,
      'totalAmount': 42000.0,
      'paymentMode': 'CASH',
      'status': 'APPROVED',
    },
    {
      'id': 'PUR-20250620-003',
      'date': '2025-06-20T00:00:00Z',
      'supplierName': 'Mumbai Bullion Traders',
      'supplierMobile': '+91 99887 77665',
      'billNo': 'MBT/2025/089',
      'purchaseType': 'BULLION',
      'metalType': 'GOLD24K',
      'itemName': 'Gold Bar 50g',
      'grossWeight': 50.10,
      'netWeight': 50.00,
      'purity': 99.9,
      'rate': 6100.0,
      'amount': 305000.0,
      'gst': 0.0,
      'totalAmount': 305000.0,
      'paymentMode': 'CREDIT',
      'status': 'APPROVED',
    },
    {
      'id': 'PUR-20250619-004',
      'date': '2025-06-19T00:00:00Z',
      'supplierName': 'Ramesh Jewellers',
      'supplierMobile': '+91 98765 43210',
      'billNo': 'BJ/2025/041',
      'purchaseType': 'NEWINVENTORY',
      'metalType': 'SILVER',
      'itemName': 'Silver Bar 100g',
      'grossWeight': 100.50,
      'netWeight': 100.00,
      'purity': 99.0,
      'rate': 75.0,
      'amount': 7500.0,
      'gst': 0.0,
      'totalAmount': 7500.0,
      'paymentMode': 'CASH',
      'status': 'APPROVED',
    },
  ];

  static final List<Map<String, dynamic>> _suppliers = [
    {
      'id': 'supp-001',
      'name': 'Ramesh Jewellers',
      'mobile': '+91 98765 43210',
      'gstNo': '27ABCDE1234F1Z5',
      'balanceDue': 125000.0,
      'status': 'ACTIVE',
    },
    {
      'id': 'supp-002',
      'name': 'Shree Gold House',
      'mobile': '+91 91234 56789',
      'gstNo': '27FGHIJ5678K2L6',
      'balanceDue': 45000.0,
      'status': 'ACTIVE',
    },
    {
      'id': 'supp-003',
      'name': 'Mumbai Bullion Traders',
      'mobile': '+91 99887 77665',
      'gstNo': '27KLMNO9012P3Q7',
      'balanceDue': 305000.0,
      'status': 'ACTIVE',
    },
    {
      'id': 'supp-004',
      'name': 'Pune Silver Emporium',
      'mobile': '+91 88776 65544',
      'gstNo': '27PQRST3456U4V8',
      'balanceDue': 0.0,
      'status': 'INACTIVE',
    },
  ];

  static final List<Map<String, dynamic>> _vaultOccupancy = [
    {'vaultName': 'Vault-A', 'occupied': 42, 'total': 80},
    {'vaultName': 'Vault-B', 'occupied': 64, 'total': 80},
    {'vaultName': 'Vault-C', 'occupied': 18, 'total': 60},
  ];

  static final List<Map<String, dynamic>> _vaultSearchResults = [
    {
      'customerName': 'Ramesh Patil',
      'girviId': 'GRV-2026-000042',
      'serialId': 'SA-2026-000042',
      'status': 'Active',
      'coordinate': 'VA-A/SF-02/TR-05/SL-18',
      'mobile': '9876543210',
    },
    {
      'customerName': 'Suresh Jadhav',
      'girviId': 'GRV-2026-000038',
      'serialId': 'SA-2026-000038',
      'status': 'Partial Paid',
      'coordinate': 'VA-A/SF-01/TR-03/SL-07',
      'mobile': '9123456780',
    },
    {
      'customerName': 'Asha Desai',
      'girviId': 'GRV-2026-000021',
      'serialId': 'SA-2026-000021',
      'status': 'Renewed',
      'coordinate': 'VA-B/SF-03/TR-08/SL-02',
      'mobile': '9988776655',
    },
    {
      'customerName': 'Meena Jadhav',
      'girviId': 'GRV-2026-000520',
      'serialId': 'SA-2026-000520',
      'status': 'Active',
      'coordinate': 'VA-A/SF-01/TR-03/SL-07',
      'mobile': '8765432109',
    },
    {
      'customerName': 'Amol Deshmukh',
      'girviId': 'GRV-2026-000519',
      'serialId': 'SA-2026-000519',
      'status': 'Overdue',
      'coordinate': 'VA-B/SF-03/TR-01/SL-12',
      'mobile': '7654321098',
    },
  ];

  static final Map<String, dynamic> _interestLedger = {
    'girviId': 'GRV-2026-000042',
    'customerName': 'रमेश पाटील',
    'customerNameEn': 'Ramesh Patil',
    'principal': 100000.0,
    'interestType': 'simple',
    'interestRate': 12.0,
    'entries': [
      {
        'date': '2026-01-01T00:00:00Z',
        'type': 'ACCRUAL',
        'openingPrincipal': 100000.0,
        'interest': 0.0,
        'penalty': 0.0,
        'payment': 0.0,
        'closingPrincipal': 100000.0,
        'notes': null,
      },
      {
        'date': '2026-01-31T00:00:00Z',
        'type': 'ACCRUAL',
        'openingPrincipal': 100000.0,
        'interest': 986.30,
        'penalty': 0.0,
        'payment': 0.0,
        'closingPrincipal': 100000.0,
        'notes': null,
      },
      {
        'date': '2026-02-28T00:00:00Z',
        'type': 'ACCRUAL',
        'openingPrincipal': 100000.0,
        'interest': 1013.70,
        'penalty': 0.0,
        'payment': 0.0,
        'closingPrincipal': 100000.0,
        'notes': null,
      },
      {
        'date': '2026-03-15T00:00:00Z',
        'type': 'PAYMENT',
        'openingPrincipal': 100000.0,
        'interest': 0.0,
        'penalty': 0.0,
        'payment': 5000.0,
        'closingPrincipal': 95000.0,
        'notes': 'Partial interest payment',
      },
      {
        'date': '2026-06-30T00:00:00Z',
        'type': 'ACCRUAL',
        'openingPrincipal': 95000.0,
        'interest': 4931.51,
        'penalty': 0.0,
        'payment': 0.0,
        'closingPrincipal': 95000.0,
        'notes': null,
      },
    ],
  };

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

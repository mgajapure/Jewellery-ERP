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

      // Sales — create new sale
      if (path == ApiEndpoints.sales) {
        final body = _extractBody(options) ?? {};
        final now = DateTime.now();
        final invoiceNo =
            'INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${(100 + _salesLedger.length).toString().padLeft(6, '0')}';
        final itemIds =
            (body['itemIds'] as List?)?.cast<String>() ?? <String>[];
        final discount = (body['discount'] as num?)?.toDouble() ?? 0.0;
        final items = itemIds.isEmpty
            ? [_inventoryItems.first]
            : itemIds
                .map((id) => _inventoryItems.firstWhere(
                    (i) => i['id'] == id,
                    orElse: () => _inventoryItems.first))
                .toList();
        final subtotal = items.fold<double>(
            0, (s, i) => s + (i['taxableAmount'] as num).toDouble());
        final taxable = subtotal - discount;
        final cgst = taxable * 0.015;
        final sgst = taxable * 0.015;
        final order = {
          'invoiceNo': invoiceNo,
          'date': now.toIso8601String(),
          'customerId': body['customerId'] ?? 'walk-in',
          'customerName': body['customerName'] ?? 'Walk-in Customer',
          'customerMobile': body['customerMobile'] ?? '',
          'items': items,
          'subtotal': subtotal,
          'discount': discount,
          'cgst': cgst,
          'sgst': sgst,
          'totalAmount': taxable + cgst + sgst,
          'paymentMode': body['paymentMode'] ?? 'CASH',
          'status': 'COMPLETED',
          'createdAt': now.toIso8601String(),
        };
        return {'success': true, 'data': order};
      }

      // Sales return
      if (path == ApiEndpoints.salesReturn) {
        return {'success': true, 'message': 'Return processed.'};
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

      // Compliance — generate form
      if (path == ApiEndpoints.complianceGenerate) {
        final body = _extractBody(options) ?? {};
        final formType = body['form'] as String? ?? '';
        return {
          'success': true,
          'data': {
            'formType': formType,
            'generatedAt': DateTime.now().toIso8601String(),
            'fileUrl': 'mock://${formType.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}.pdf',
          },
        };
      }

      // Inventory — create new item
      if (path == ApiEndpoints.inventory) {
        final body = _extractBody(options) ?? {};
        final now = DateTime.now();
        final newItem = <String, dynamic>{
          'id': 'inv-${now.millisecondsSinceEpoch}',
          'barcode': 'ITM-${(1000 + _inventoryItems.length + 1).toString()}',
          'name': body['name'] ?? 'New Item',
          'category': body['category'] ?? 'Gold Jewellery',
          'description': body['description'] ?? '',
          'metalType': body['metalType'] ?? 'Gold',
          'grossWeight': (body['grossWeight'] as num?)?.toDouble() ?? 0.0,
          'netWeight': (body['netWeight'] as num?)?.toDouble() ?? 0.0,
          'purity': body['purity'] ?? '22K',
          'purityValue': (body['purityValue'] as num?)?.toDouble() ?? 91.67,
          'makingCharges': (body['makingCharges'] as num?)?.toDouble() ?? 0.0,
          'costPrice': (body['costPrice'] as num?)?.toDouble() ?? 0.0,
          'sellingPrice': (body['sellingPrice'] as num?)?.toDouble() ?? 0.0,
          'taxableAmount': (body['sellingPrice'] as num?)?.toDouble() ?? 0.0,
          'gst': ((body['sellingPrice'] as num?)?.toDouble() ?? 0.0) * 0.03,
          'totalAmount':
              ((body['sellingPrice'] as num?)?.toDouble() ?? 0.0) * 1.03,
          'status': 'AVAILABLE',
          'movements': [
            {
              'date': '${now.day} ${_monthName(now.month)} ${now.year}',
              'action': 'Created',
              'user': 'Staff',
              'reference': '-',
            },
          ],
        };
        _inventoryItems.add(newItem);
        return {'success': true, 'data': newItem};
      }

      // Girvi — create new girvi
      if (path == ApiEndpoints.girvi) {
        final body = _extractBody(options) ?? {};
        final now = DateTime.now();
        final newId = 'grv-${now.millisecondsSinceEpoch}';
        final serialNo = (_girviList.length + 522).toString().padLeft(6, '0');
        final items = (body['items'] as List<dynamic>?)?.map((item) {
          final m = item as Map<String, dynamic>;
          final gross = (m['grossWeightG'] as num?)?.toDouble() ?? 0.0;
          final stone = (m['stoneWeightG'] as num?)?.toDouble() ?? 0.0;
          final net = (m['netWeightG'] as num?)?.toDouble() ?? (gross - stone);
          final purity = m['purity'] as String? ?? '22K';
          final purityFactor = purity == '24K' ? 1.0 : purity == '22K' ? 22/24 : purity == '20K' ? 20/24 : 18/24;
          final valuation = net * purityFactor * 7185.0;
          return {
            'id': 'item-${now.millisecondsSinceEpoch}-${_girviList.length}',
            'description': m['description'] ?? '',
            'itemType': m['itemType'] ?? 'Ring',
            'quantity': m['quantity'] ?? 1,
            'grossWeightG': gross,
            'stoneWeightG': stone,
            'netWeightG': net,
            'purity': purity,
            'metalType': m['metalType'] ?? 'gold',
            'valuationAmount': valuation,
            'photoUrls': [],
          };
        }).toList() ?? [];
        final dueDate = body['dueDate'] as String? ?? now.add(const Duration(days: 30)).toIso8601String();
        final loanAmount = (body['loanAmount'] as num?)?.toDouble() ?? 0.0;
        final newGirvi = {
          'id': newId,
          'serialId': 'GRV-${now.year}-$serialNo',
          'tenantId': 'tenant-001',
          'customerId': body['customerId'] ?? 'cust-001',
          'customerName': 'सुरेश पाटील',
          'customerNameEn': 'Suresh Patil',
          'customerMobile': '+91 98765 43210',
          'status': 'active',
          'loanAmount': loanAmount,
          'outstandingAmount': loanAmount,
          'accruedInterest': 0.0,
          'penaltyAmount': 0.0,
          'interestRate': (body['interestRate'] as num?)?.toDouble() ?? 18.0,
          'interestType': body['interestType'] ?? 'simple',
          'penaltyRate': (body['penaltyRate'] as num?)?.toDouble() ?? 2.0,
          'startDate': body['startDate'] ?? now.toIso8601String(),
          'dueDate': dueDate,
          'daysLeft': 30,
          'vaultLocation': body['vaultLocation'] ?? 'VA-A/SF-02/TR-05/SL-18',
          'kfsDocUrl': null,
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
          'version': 1,
          'items': items,
          'payments': [],
        };
        _girviList.add(newGirvi);
        return {'success': true, 'data': newGirvi};
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

    if (method == 'PUT') {
      // Customer — update
      if (path.startsWith('/customers/') && path.split('/').length == 3) {
        final id = path.split('/')[2];
        final body = _extractBody(options) ?? {};
        final idx = _customers.indexWhere((c) => c['id'] == id);
        if (idx != -1) {
          _customers[idx] = Map<String, dynamic>.from(_customers[idx])
            ..['name'] = body['name'] ?? _customers[idx]['name']
            ..['alternateMobile'] =
                body['alternateMobile'] ?? _customers[idx]['alternateMobile']
            ..['address'] = body['address'] ?? _customers[idx]['address']
            ..['panNumber'] = body['panNumber'] ?? _customers[idx]['panNumber']
            ..['dateOfBirth'] =
                body['dateOfBirth'] ?? _customers[idx]['dateOfBirth']
            ..['updatedAt'] = DateTime.now().toIso8601String();
          return {'success': true, 'data': _customers[idx]};
        }
        return {'success': false, 'message': 'Customer not found.'};
      }

      // Inventory — update status
      if (path.startsWith('/inventory/') && path.split('/').length == 3) {
        final id = path.split('/')[2];
        final body = _extractBody(options) ?? {};
        final newStatus = body['status'] as String? ?? 'AVAILABLE';
        final idx = _inventoryItems.indexWhere((i) => i['id'] == id);
        if (idx != -1) {
          _inventoryItems[idx] = Map<String, dynamic>.from(_inventoryItems[idx])
            ..['status'] = newStatus;
          return {'success': true, 'data': _inventoryItems[idx]};
        }
        return {'success': false, 'message': 'Item not found.'};
      }
    }

    switch (path) {
      case ApiEndpoints.savingsDashboard:
        return {'success': true, 'data': _savingsDashboard};

      case ApiEndpoints.reportsDashboard:
        final p = (query['period'] as String? ?? 'month');
        return {'success': true, 'data': _reportsDashboard(p)};

      case ApiEndpoints.complianceDashboard:
        return {'success': true, 'data': _complianceDashboard};

      case ApiEndpoints.complianceForm9:
        return {
          'success': true,
          'data': {
            'period': '01 Jan 2026 – 31 Jan 2026',
            'rows': _form9Rows,
          },
        };

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

      case ApiEndpoints.inventory:
        final invFilter = (query['filter'] as String? ?? '').toUpperCase();
        final invQ = (query['q'] as String? ?? '').toLowerCase();
        var inventoryList = _inventoryItems.toList();
        if (invFilter.isNotEmpty) {
          inventoryList = inventoryList
              .where((i) => i['status'] == invFilter)
              .toList();
        }
        if (invQ.isNotEmpty) {
          inventoryList = inventoryList.where((i) {
            return (i['name'] as String).toLowerCase().contains(invQ) ||
                (i['barcode'] as String).toLowerCase().contains(invQ) ||
                (i['category'] as String).toLowerCase().contains(invQ);
          }).toList();
        }
        return {'success': true, 'data': inventoryList};

      case ApiEndpoints.salesDashboard:
        return {'success': true, 'data': _salesDashboardStats};

      case ApiEndpoints.salesLedger:
        final sFilter = (query['filter'] as String? ?? '').toUpperCase();
        final sQ = (query['q'] as String? ?? '').toLowerCase();
        var orders = _salesLedger.toList();
        if (sFilter.isNotEmpty) {
          orders =
              orders.where((o) => o['status'] == sFilter).toList();
        }
        if (sQ.isNotEmpty) {
          orders = orders.where((o) {
            return (o['customerName'] as String)
                    .toLowerCase()
                    .contains(sQ) ||
                (o['invoiceNo'] as String).toLowerCase().contains(sQ);
          }).toList();
        }
        return {'success': true, 'data': orders};

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

        if (path.startsWith('/sales/') &&
            !path.contains('/return') &&
            path.split('/').length == 3) {
          final invoiceNo = path.split('/')[2];
          final order = _salesLedger.firstWhere(
            (o) => o['invoiceNo'] == invoiceNo,
            orElse: () => _salesLedger.first,
          );
          return {'success': true, 'data': order};
        }

        if (path.startsWith('/inventory/') &&
            !path.contains('/barcode/') &&
            path.split('/').length == 3) {
          final id = path.split('/')[2];
          final item = _inventoryItems.firstWhere(
            (i) => i['id'] == id,
            orElse: () => <String, dynamic>{},
          );
          if (item.isNotEmpty) {
            return {'success': true, 'data': item};
          }
          return {'success': false, 'message': 'Item not found.'};
        }

        if (path.startsWith('/inventory/barcode/')) {
          final barcode = path.split('/').last;
          final item = _inventoryItems.firstWhere(
            (i) => i['barcode'] == barcode,
            orElse: () => <String, dynamic>{},
          );
          if (item.isNotEmpty) {
            return {'success': true, 'data': item};
          }
          return {'success': false, 'message': 'Item not found.'};
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

  static final Map<String, dynamic> _salesDashboardStats = {
    'todaySales': 12,
    'todayRevenue': 380000.0,
    'monthlyRevenue': 2850000.0,
    'avgInvoice': 31750.0,
    'topCategory': 'Gold Chain',
    'pendingReturns': 2,
  };

  static final List<Map<String, dynamic>> _salesLedger = [
    {
      'invoiceNo': 'INV-2026-000102',
      'date': '2026-06-22T00:00:00Z',
      'customerId': 'cust-001',
      'customerName': 'Ramesh Patil',
      'customerMobile': '+91 98765 43210',
      'items': [
        {
          'id': 'inv-1001',
          'name': 'Gold Chain 22K',
          'barcode': 'ITM-1001',
          'grossWeight': 24.50,
          'netWeight': 24.20,
          'purity': 91.6,
          'taxableAmount': 125000.0,
          'gst': 3750.0,
          'totalAmount': 128750.0,
        },
        {
          'id': 'inv-1002',
          'name': 'Gold Ring 22K',
          'barcode': 'ITM-1002',
          'grossWeight': 8.20,
          'netWeight': 8.00,
          'purity': 91.6,
          'taxableAmount': 42000.0,
          'gst': 1260.0,
          'totalAmount': 43260.0,
        },
      ],
      'subtotal': 167000.0,
      'discount': 0.0,
      'cgst': 2505.0,
      'sgst': 2505.0,
      'totalAmount': 172010.0,
      'paymentMode': 'UPI',
      'status': 'COMPLETED',
      'createdAt': '2026-06-22T11:30:00Z',
    },
    {
      'invoiceNo': 'INV-2026-000101',
      'date': '2026-06-21T00:00:00Z',
      'customerId': 'cust-002',
      'customerName': 'Meena Jadhav',
      'customerMobile': '+91 87654 32109',
      'items': [
        {
          'id': 'inv-1003',
          'name': 'Gold Earrings 22K',
          'barcode': 'ITM-1003',
          'grossWeight': 6.50,
          'netWeight': 6.20,
          'purity': 91.6,
          'taxableAmount': 40000.0,
          'gst': 1200.0,
          'totalAmount': 41200.0,
        },
      ],
      'subtotal': 40000.0,
      'discount': 500.0,
      'cgst': 593.0,
      'sgst': 593.0,
      'totalAmount': 40686.0,
      'paymentMode': 'CASH',
      'status': 'COMPLETED',
      'createdAt': '2026-06-21T14:20:00Z',
    },
    {
      'invoiceNo': 'INV-2026-000100',
      'date': '2026-06-20T00:00:00Z',
      'customerId': 'cust-003',
      'customerName': 'Amol Deshmukh',
      'customerMobile': '+91 76543 21098',
      'items': [
        {
          'id': 'inv-1004',
          'name': 'Gold Necklace 22K',
          'barcode': 'ITM-1004',
          'grossWeight': 45.00,
          'netWeight': 44.50,
          'purity': 91.6,
          'taxableAmount': 275000.0,
          'gst': 8250.0,
          'totalAmount': 283250.0,
        },
      ],
      'subtotal': 275000.0,
      'discount': 0.0,
      'cgst': 4125.0,
      'sgst': 4125.0,
      'totalAmount': 283250.0,
      'paymentMode': 'BANK_TRANSFER',
      'status': 'RETURNED',
      'createdAt': '2026-06-20T10:00:00Z',
    },
    {
      'invoiceNo': 'INV-2026-000099',
      'date': '2026-06-19T00:00:00Z',
      'customerId': 'cust-004',
      'customerName': 'Suresh Patil',
      'customerMobile': '+91 65432 10987',
      'items': [
        {
          'id': 'inv-1005',
          'name': 'Gold Bangle 22K',
          'barcode': 'ITM-1005',
          'grossWeight': 20.00,
          'netWeight': 19.80,
          'purity': 91.6,
          'taxableAmount': 125000.0,
          'gst': 3750.0,
          'totalAmount': 128750.0,
        },
      ],
      'subtotal': 125000.0,
      'discount': 0.0,
      'cgst': 1875.0,
      'sgst': 1875.0,
      'totalAmount': 128750.0,
      'paymentMode': 'UPI',
      'status': 'COMPLETED',
      'createdAt': '2026-06-19T09:15:00Z',
    },
  ];

  static String _monthName(int m) => const [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m];

  static final List<Map<String, dynamic>> _inventoryItems = [
    {
      'id': 'inv-1001',
      'barcode': 'ITM-1001',
      'name': 'Gold Chain 22K',
      'category': 'Gold Jewellery',
      'description': 'Traditional 22K gold chain with intricate design. Hallmarked and certified.',
      'metalType': 'Gold',
      'grossWeight': 24.50,
      'netWeight': 24.20,
      'purity': '22K',
      'purityValue': 91.67,
      'makingCharges': 12500.0,
      'costPrice': 100000.0,
      'sellingPrice': 125000.0,
      'taxableAmount': 125000.0,
      'gst': 3750.0,
      'totalAmount': 128750.0,
      'status': 'AVAILABLE',
      'movements': [
        {'date': '15 Jan 2026', 'action': 'Created', 'user': 'Admin', 'reference': 'PUR-20250622-001'},
        {'date': '20 Jan 2026', 'action': 'Available', 'user': 'System', 'reference': '-'},
      ],
    },
    {
      'id': 'inv-1002',
      'barcode': 'ITM-1002',
      'name': 'Gold Ring 22K',
      'category': 'Gold Jewellery',
      'description': 'Classic 22K gold ring with smooth finish. BIS hallmarked.',
      'metalType': 'Gold',
      'grossWeight': 8.20,
      'netWeight': 8.00,
      'purity': '22K',
      'purityValue': 91.67,
      'makingCharges': 3500.0,
      'costPrice': 35000.0,
      'sellingPrice': 42000.0,
      'taxableAmount': 42000.0,
      'gst': 1260.0,
      'totalAmount': 43260.0,
      'status': 'AVAILABLE',
      'movements': [
        {'date': '15 Jan 2026', 'action': 'Created', 'user': 'Admin', 'reference': 'PUR-20250622-001'},
        {'date': '18 Jan 2026', 'action': 'Available', 'user': 'System', 'reference': '-'},
      ],
    },
    {
      'id': 'inv-1003',
      'barcode': 'ITM-1003',
      'name': 'Gold Earrings 22K',
      'category': 'Gold Jewellery',
      'description': 'Elegant 22K gold earrings with floral design. Suitable for daily wear.',
      'metalType': 'Gold',
      'grossWeight': 6.50,
      'netWeight': 6.20,
      'purity': '22K',
      'purityValue': 91.67,
      'makingCharges': 3000.0,
      'costPrice': 32000.0,
      'sellingPrice': 40000.0,
      'taxableAmount': 40000.0,
      'gst': 1200.0,
      'totalAmount': 41200.0,
      'status': 'RESERVED',
      'movements': [
        {'date': '16 Jan 2026', 'action': 'Created', 'user': 'Admin', 'reference': 'PUR-20250621-002'},
        {'date': '22 Jan 2026', 'action': 'Reserved', 'user': 'Staff', 'reference': '-'},
      ],
    },
    {
      'id': 'inv-1004',
      'barcode': 'ITM-1004',
      'name': 'Gold Necklace 22K',
      'category': 'Gold Jewellery',
      'description': 'Heavy 22K gold necklace with traditional design. Premium craftsmanship.',
      'metalType': 'Gold',
      'grossWeight': 45.00,
      'netWeight': 44.50,
      'purity': '22K',
      'purityValue': 91.67,
      'makingCharges': 25000.0,
      'costPrice': 235000.0,
      'sellingPrice': 275000.0,
      'taxableAmount': 275000.0,
      'gst': 8250.0,
      'totalAmount': 283250.0,
      'status': 'SOLD',
      'movements': [
        {'date': '10 Jan 2026', 'action': 'Created', 'user': 'Admin', 'reference': 'PUR-20250620-003'},
        {'date': '20 Jun 2026', 'action': 'Sold', 'user': 'Staff', 'reference': 'INV-2026-000100'},
      ],
    },
    {
      'id': 'inv-1005',
      'barcode': 'ITM-1005',
      'name': 'Gold Bangle 22K',
      'category': 'Gold Jewellery',
      'description': '22K gold bangle set with broad design and fine polish.',
      'metalType': 'Gold',
      'grossWeight': 20.00,
      'netWeight': 19.80,
      'purity': '22K',
      'purityValue': 91.67,
      'makingCharges': 10000.0,
      'costPrice': 105000.0,
      'sellingPrice': 125000.0,
      'taxableAmount': 125000.0,
      'gst': 3750.0,
      'totalAmount': 128750.0,
      'status': 'LOW_STOCK',
      'movements': [
        {'date': '12 Jan 2026', 'action': 'Created', 'user': 'Admin', 'reference': 'PUR-20250619-004'},
        {'date': '19 Jan 2026', 'action': 'Available', 'user': 'System', 'reference': '-'},
      ],
    },
    {
      'id': 'inv-1006',
      'barcode': 'ITM-1006',
      'name': 'Diamond Ring 18K',
      'category': 'Diamond Jewellery',
      'description': '18K white gold diamond solitaire ring. Certified 0.5 ct VS1 clarity.',
      'metalType': 'Gold',
      'grossWeight': 4.20,
      'netWeight': 3.80,
      'purity': '18K',
      'purityValue': 75.0,
      'makingCharges': 8000.0,
      'costPrice': 55000.0,
      'sellingPrice': 68000.0,
      'taxableAmount': 68000.0,
      'gst': 2040.0,
      'totalAmount': 70040.0,
      'status': 'AVAILABLE',
      'movements': [
        {'date': '02 Feb 2026', 'action': 'Created', 'user': 'Admin', 'reference': 'PUR-20250619-004'},
        {'date': '05 Feb 2026', 'action': 'Available', 'user': 'System', 'reference': '-'},
      ],
    },
    {
      'id': 'inv-1007',
      'barcode': 'ITM-1007',
      'name': 'Silver Payal',
      'category': 'Silver Jewellery',
      'description': 'Sterling silver payal set with traditional ghungroo design.',
      'metalType': 'Silver',
      'grossWeight': 25.00,
      'netWeight': 24.50,
      'purity': '925',
      'purityValue': 92.5,
      'makingCharges': 1200.0,
      'costPrice': 9500.0,
      'sellingPrice': 12000.0,
      'taxableAmount': 12000.0,
      'gst': 360.0,
      'totalAmount': 12360.0,
      'status': 'AVAILABLE',
      'movements': [
        {'date': '20 Mar 2026', 'action': 'Created', 'user': 'Admin', 'reference': 'PUR-20250619-004'},
        {'date': '22 Mar 2026', 'action': 'Available', 'user': 'System', 'reference': '-'},
      ],
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

  static const Map<String, dynamic> _complianceDashboard = {
    'healthScore': 94,
    'metrics': [
      {'labelMr': 'सक्रिय गिरवी', 'labelEn': 'Active Girvi', 'value': '124', 'color': 0xFF061C49},
      {'labelMr': 'LTV उल्लंघने', 'labelEn': 'LTV Violations', 'value': '2', 'color': 0xFFE21B2D},
      {'labelMr': 'प्रलंबित KFS', 'labelEn': 'Pending KFS', 'value': '5', 'color': 0xFFF59E0B},
      {'labelMr': 'विमा कालबाह्य', 'labelEn': 'Insurance Expiry', 'value': '1', 'color': 0xFFE21B2D},
      {'labelMr': 'लिलाव सूचना', 'labelEn': 'Auction Notices', 'value': '3', 'color': 0xFFF59E0B},
      {'labelMr': 'सोने परत देय', 'labelEn': 'Gold Return Due', 'value': '7', 'color': 0xFF07934A},
    ],
    'alerts': [
      {
        'title': 'LTV violation detected',
        'subtitle': 'GRV-2026-000055 exceeds 85% LTV limit',
        'severity': 'high',
        'time': '2h ago',
      },
      {
        'title': 'Insurance expiring soon',
        'subtitle': 'Vault-B policy expires on 30 Jun 2026',
        'severity': 'medium',
        'time': '1d ago',
      },
      {
        'title': 'KFS pending acknowledgement',
        'subtitle': '3 customers have not acknowledged KFS',
        'severity': 'medium',
        'time': '2d ago',
      },
      {
        'title': 'Gold return window closing',
        'subtitle': 'GRV-2026-000021 return due in 2 days',
        'severity': 'low',
        'time': '3d ago',
      },
    ],
  };

  static const List<Map<String, dynamic>> _form9Rows = [
    {'date': '01 Jan 2026', 'girviCount': 4, 'totalLoan': 185000.0, 'payments': 12000.0, 'interest': 2100.0},
    {'date': '02 Jan 2026', 'girviCount': 2, 'totalLoan': 75000.0, 'payments': 5000.0, 'interest': 950.0},
    {'date': '03 Jan 2026', 'girviCount': 5, 'totalLoan': 220000.0, 'payments': 15000.0, 'interest': 2800.0},
    {'date': '04 Jan 2026', 'girviCount': 3, 'totalLoan': 140000.0, 'payments': 8000.0, 'interest': 1650.0},
    {'date': '05 Jan 2026', 'girviCount': 6, 'totalLoan': 310000.0, 'payments': 22000.0, 'interest': 3200.0},
    {'date': '06 Jan 2026', 'girviCount': 1, 'totalLoan': 45000.0, 'payments': 3000.0, 'interest': 500.0},
    {'date': '07 Jan 2026', 'girviCount': 4, 'totalLoan': 190000.0, 'payments': 14000.0, 'interest': 2000.0},
  ];

  static const Map<String, dynamic> _savingsDashboard = {
    'activeSubscriptions': 48,
    'collectedThisMonth': 240000.0,
    'totalCollected': 1850000.0,
    'activePlans': 3,
    'plans': [
      {
        'id': 'plan-11',
        'nameMr': '११ महिन्यांची योजना',
        'nameEn': '11-Month Gold Scheme',
        'durationMonths': 11,
        'monthlyAmount': 5000.0,
        'bonusMonths': 1,
        'activeSubscribers': 24,
        'isActive': true,
      },
      {
        'id': 'plan-21',
        'nameMr': '२१ महिन्यांची योजना',
        'nameEn': '21-Month Gold Scheme',
        'durationMonths': 21,
        'monthlyAmount': 3000.0,
        'bonusMonths': 2,
        'activeSubscribers': 16,
        'isActive': true,
      },
      {
        'id': 'plan-51',
        'nameMr': '५१ महिन्यांची योजना',
        'nameEn': '51-Month Diamond Scheme',
        'durationMonths': 51,
        'monthlyAmount': 2000.0,
        'bonusMonths': 3,
        'activeSubscribers': 8,
        'isActive': true,
      },
    ],
    'recentSubscriptions': [
      {
        'id': 'sub-001',
        'customerName': 'रमेश पाटील / Ramesh Patil',
        'customerId': 'cust-001',
        'planNameMr': '११ महिन्यांची योजना',
        'planNameEn': '11-Month Gold Scheme',
        'monthlyAmount': 5000.0,
        'paidInstallments': 7,
        'totalInstallments': 11,
        'nextDueDate': '01 Jul 2026',
        'totalPaid': 35000.0,
        'status': 'active',
      },
      {
        'id': 'sub-002',
        'customerName': 'सुरेश जाधव / Suresh Jadhav',
        'customerId': 'cust-002',
        'planNameMr': '२१ महिन्यांची योजना',
        'planNameEn': '21-Month Gold Scheme',
        'monthlyAmount': 3000.0,
        'paidInstallments': 15,
        'totalInstallments': 21,
        'nextDueDate': '05 Jul 2026',
        'totalPaid': 45000.0,
        'status': 'active',
      },
      {
        'id': 'sub-003',
        'customerName': 'प्रिया शर्मा / Priya Sharma',
        'customerId': 'cust-003',
        'planNameMr': '११ महिन्यांची योजना',
        'planNameEn': '11-Month Gold Scheme',
        'monthlyAmount': 5000.0,
        'paidInstallments': 11,
        'totalInstallments': 11,
        'nextDueDate': '-',
        'totalPaid': 55000.0,
        'status': 'completed',
      },
      {
        'id': 'sub-004',
        'customerName': 'अनिल कुमार / Anil Kumar',
        'customerId': 'cust-004',
        'planNameMr': '५१ महिन्यांची योजना',
        'planNameEn': '51-Month Diamond Scheme',
        'monthlyAmount': 2000.0,
        'paidInstallments': 3,
        'totalInstallments': 51,
        'nextDueDate': '10 Jul 2026',
        'totalPaid': 6000.0,
        'status': 'active',
      },
    ],
  };

  static Map<String, dynamic> _reportsDashboard(String period) {
    final multiplier = switch (period) {
      'today' => 0.033,
      'week' => 0.23,
      'year' => 12.0,
      _ => 1.0,
    };
    final periodLabel = switch (period) {
      'today' => 'Today / आज',
      'week' => 'This Week / या आठवड्यात',
      'year' => 'This Year / या वर्षात',
      _ => 'This Month / या महिन्यात',
    };
    return {
      'period': periodLabel,
      'sales': {
        'totalRevenue': 485000.0 * multiplier,
        'totalOrders': (42 * multiplier).round(),
        'avgOrderValue': 11548.0,
        'growthPercent': 12.4,
        'categories': [
          {
            'labelMr': 'सोन्याचे दागिने',
            'labelEn': 'Gold Jewellery',
            'amount': 290000.0 * multiplier,
            'percentage': 59.8,
            'color': 0xFFE7A726,
          },
          {
            'labelMr': 'चांदीचे दागिने',
            'labelEn': 'Silver Jewellery',
            'amount': 98000.0 * multiplier,
            'percentage': 20.2,
            'color': 0xFF9CA3AF,
          },
          {
            'labelMr': 'हिऱ्याचे दागिने',
            'labelEn': 'Diamond Jewellery',
            'amount': 72000.0 * multiplier,
            'percentage': 14.8,
            'color': 0xFF6366F1,
          },
          {
            'labelMr': 'इतर',
            'labelEn': 'Others',
            'amount': 25000.0 * multiplier,
            'percentage': 5.2,
            'color': 0xFF5E6880,
          },
        ],
      },
      'girvi': {
        'totalDisbursed': 1240000.0 * multiplier,
        'totalRepaid': 380000.0 * multiplier,
        'activeLoans': (124 * (period == 'today' ? 1 : 1)).round(),
        'overdueLoans': 18,
        'interestCollected': 96000.0 * multiplier,
        'avgLoanAmount': 10000.0,
      },
      'purchase': {
        'totalPurchased': 320000.0 * multiplier,
        'totalWeight': 450.0 * multiplier,
        'avgRate': 7200.0,
        'uniqueSuppliers': period == 'today' ? 2 : (period == 'week' ? 5 : 12),
      },
    };
  }
}

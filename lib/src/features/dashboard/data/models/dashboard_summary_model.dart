import '../../domain/entities/dashboard_summary.dart';

class RecentPaymentModel {
  const RecentPaymentModel({
    required this.id,
    required this.customerName,
    required this.customerNameEn,
    required this.girviSerial,
    required this.paymentType,
    required this.amount,
    required this.paidAt,
  });

  factory RecentPaymentModel.fromJson(Map<String, dynamic> json) =>
      RecentPaymentModel(
        id: json['id'] as String,
        customerName: json['customerName'] as String,
        customerNameEn: json['customerNameEn'] as String,
        girviSerial: json['girviSerial'] as String? ?? '',
        paymentType: _parseType(json['paymentType'] as String? ?? 'partial'),
        amount: (json['amount'] as num).toDouble(),
        paidAt: DateTime.parse(json['paidAt'] as String),
      );

  static RecentPaymentType _parseType(String v) {
    switch (v) {
      case 'interest':
        return RecentPaymentType.interest;
      case 'principal':
        return RecentPaymentType.principal;
      case 'renewal':
        return RecentPaymentType.renewal;
      case 'redemption':
        return RecentPaymentType.redemption;
      default:
        return RecentPaymentType.partial;
    }
  }

  final String id;
  final String customerName;
  final String customerNameEn;
  final String girviSerial;
  final RecentPaymentType paymentType;
  final double amount;
  final DateTime paidAt;

  RecentPayment toEntity() => RecentPayment(
    id: id,
    customerName: customerName,
    customerNameEn: customerNameEn,
    girviSerial: girviSerial,
    paymentType: paymentType,
    amount: amount,
    paidAt: paidAt,
  );
}

class DashboardSummaryModel {
  const DashboardSummaryModel({
    required this.activeGirvi,
    required this.dueToday,
    required this.overdue,
    required this.collectionsToday,
    required this.loanExposure,
    required this.goldRatePerGram,
    required this.goldRateChange,
    required this.goldRateChangePct,
    required this.goldRateSource,
    required this.goldRateUpdatedAt,
    required this.recentPayments,
    required this.newGirviToday,
    required this.disbursedToday,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      DashboardSummaryModel(
        // Support both real backend field names and legacy mock field names.
        activeGirvi: (json['totalActiveLoans'] as num? ??
                json['activeGirvi'] as num? ??
                0)
            .toInt(),
        dueToday: (json['dueToday'] as num? ?? 0).toInt(),
        overdue: (json['overdueLoans'] as num? ??
                json['overdue'] as num? ??
                0)
            .toInt(),
        collectionsToday: (json['todayCollections'] as num? ??
                json['todaySales'] as num? ??
                json['collectionsToday'] as num? ??
                0)
            .toDouble(),
        loanExposure: (json['totalLoanAmount'] as num? ??
                json['loanExposure'] as num? ??
                0)
            .toDouble(),
        goldRatePerGram:
            (json['goldRatePerGram'] as num? ?? 0).toDouble(),
        goldRateChange:
            (json['goldRateChange'] as num? ?? 0).toDouble(),
        goldRateChangePct:
            (json['goldRateChangePct'] as num? ?? 0).toDouble(),
        goldRateSource: json['goldRateSource'] as String? ?? 'MCX',
        goldRateUpdatedAt: json['goldRateUpdatedAt'] != null
            ? DateTime.parse(json['goldRateUpdatedAt'] as String)
            : DateTime.now(),
        recentPayments: (json['recentPayments'] as List<dynamic>? ?? [])
            .map((e) =>
                RecentPaymentModel.fromJson(e as Map<String, dynamic>)
                    .toEntity())
            .toList(),
        newGirviToday:
            (json['newGirviToday'] as num? ?? 0).toInt(),
        disbursedToday:
            (json['disbursedToday'] as num? ?? 0).toDouble(),
      );

  final int activeGirvi;
  final int dueToday;
  final int overdue;
  final double collectionsToday;
  final double loanExposure;
  final double goldRatePerGram;
  final double goldRateChange;
  final double goldRateChangePct;
  final String goldRateSource;
  final DateTime goldRateUpdatedAt;
  final List<RecentPayment> recentPayments;
  final int newGirviToday;
  final double disbursedToday;

  DashboardSummary toEntity() => DashboardSummary(
    activeGirvi: activeGirvi,
    dueToday: dueToday,
    overdue: overdue,
    collectionsToday: collectionsToday,
    loanExposure: loanExposure,
    goldRatePerGram: goldRatePerGram,
    goldRateChange: goldRateChange,
    goldRateChangePct: goldRateChangePct,
    goldRateSource: goldRateSource,
    goldRateUpdatedAt: goldRateUpdatedAt,
    recentPayments: recentPayments,
    newGirviToday: newGirviToday,
    disbursedToday: disbursedToday,
  );
}
